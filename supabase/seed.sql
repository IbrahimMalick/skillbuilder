-- IDesire Academy — development seed
-- Run after 0001_init.sql against a fresh project:
--   psql $DB_URL -f supabase/seed.sql
--
-- Idempotent: uses fixed UUIDs and ON CONFLICT to allow re-runs.
-- After running, also run `npm run build:rag` to chunk + embed transcripts.

-- ─────────────────────────────────────────────────────────────────────────────
-- Tracks (5)
-- ─────────────────────────────────────────────────────────────────────────────
insert into public.tracks (id, slug, title, description, order_index) values
  ('a1000000-0000-4000-8000-000000000001', 'foundations',
   'Foundations',
   'For the first-time founder. Find your edge, validate the idea, land the first paying customer.',
   1),
  ('a1000000-0000-4000-8000-000000000002', 'side-to-full',
   'Side hustle to full-time',
   'Engineer your exit: replace your salary, build the runway, and time the leap without breaking your family.',
   2),
  ('a1000000-0000-4000-8000-000000000003', 'scale',
   'Scale',
   'You have customers. Now build the systems, hires, and offers that let the business outgrow your inbox.',
   3),
  ('a1000000-0000-4000-8000-000000000004', 'biz-to-wealth',
   'Business to wealth',
   'Turn cash flow into capital. Tax, holding companies, investing in yourself and in others.',
   4),
  ('a1000000-0000-4000-8000-000000000005', 'legacy',
   'Legacy',
   'For the operator who has already won. Pass on what you know — to your family, your team, and the next generation.',
   5)
on conflict (id) do update set
  slug = excluded.slug,
  title = excluded.title,
  description = excluded.description,
  order_index = excluded.order_index;

-- ─────────────────────────────────────────────────────────────────────────────
-- Course: foundations / "From Idea to First Paying Customer"
-- ─────────────────────────────────────────────────────────────────────────────
insert into public.courses (id, track_id, slug, title, description, order_index)
values (
  'b1000000-0000-4000-8000-000000000001',
  'a1000000-0000-4000-8000-000000000001',
  'idea-to-first-customer',
  'From Idea to First Paying Customer',
  'A nine-lesson program. Find your edge, validate before you build, and land the first paying customer in six weeks or less.',
  1
)
on conflict (id) do update set
  title = excluded.title,
  description = excluded.description,
  order_index = excluded.order_index;

-- ─────────────────────────────────────────────────────────────────────────────
-- Modules (3)
-- ─────────────────────────────────────────────────────────────────────────────
insert into public.modules (id, course_id, title, order_index) values
  ('c1000000-0000-4000-8000-000000000001',
   'b1000000-0000-4000-8000-000000000001', 'Find your edge', 1),
  ('c1000000-0000-4000-8000-000000000002',
   'b1000000-0000-4000-8000-000000000001', 'Validate before you build', 2),
  ('c1000000-0000-4000-8000-000000000003',
   'b1000000-0000-4000-8000-000000000001', 'Land the first sale', 3)
on conflict (id) do update set
  title = excluded.title,
  order_index = excluded.order_index;

-- ─────────────────────────────────────────────────────────────────────────────
-- Lessons (9). First lesson of module 1 is a free preview.
-- video_url is a HeyGen placeholder; swap for real renders when ready.
-- ─────────────────────────────────────────────────────────────────────────────
insert into public.lessons
  (id, module_id, slug, video_url, duration_seconds, order_index, is_free_preview) values
  -- Module 1: Find your edge
  ('d1000000-0000-4000-8000-000000000001',
   'c1000000-0000-4000-8000-000000000001',
   'story-only-you-can-tell',
   'https://files.heygen.com/placeholder/idea-1-1.mp4', 360, 1, true),
  ('d1000000-0000-4000-8000-000000000002',
   'c1000000-0000-4000-8000-000000000001',
   'permission-to-be-specific',
   'https://files.heygen.com/placeholder/idea-1-2.mp4', 340, 2, false),
  ('d1000000-0000-4000-8000-000000000003',
   'c1000000-0000-4000-8000-000000000001',
   'what-you-stop-doing',
   'https://files.heygen.com/placeholder/idea-1-3.mp4', 320, 3, false),
  -- Module 2: Validate before you build
  ('d1000000-0000-4000-8000-000000000004',
   'c1000000-0000-4000-8000-000000000002',
   'sell-it-before-you-build-it',
   'https://files.heygen.com/placeholder/idea-2-1.mp4', 400, 1, false),
  ('d1000000-0000-4000-8000-000000000005',
   'c1000000-0000-4000-8000-000000000002',
   'the-five-conversations',
   'https://files.heygen.com/placeholder/idea-2-2.mp4', 380, 2, false),
  ('d1000000-0000-4000-8000-000000000006',
   'c1000000-0000-4000-8000-000000000002',
   'the-smallest-possible-test',
   'https://files.heygen.com/placeholder/idea-2-3.mp4', 360, 3, false),
  -- Module 3: Land the first sale
  ('d1000000-0000-4000-8000-000000000007',
   'c1000000-0000-4000-8000-000000000003',
   'where-your-first-ten-customers-live',
   'https://files.heygen.com/placeholder/idea-3-1.mp4', 380, 1, false),
  ('d1000000-0000-4000-8000-000000000008',
   'c1000000-0000-4000-8000-000000000003',
   'write-the-message-theyll-reply-to',
   'https://files.heygen.com/placeholder/idea-3-2.mp4', 400, 2, false),
  ('d1000000-0000-4000-8000-000000000009',
   'c1000000-0000-4000-8000-000000000003',
   'charging-more-than-feels-comfortable',
   'https://files.heygen.com/placeholder/idea-3-3.mp4', 420, 3, false)
on conflict (id) do update set
  slug = excluded.slug,
  video_url = excluded.video_url,
  duration_seconds = excluded.duration_seconds,
  order_index = excluded.order_index,
  is_free_preview = excluded.is_free_preview;

-- ─────────────────────────────────────────────────────────────────────────────
-- Lesson translations (9 lessons × 3 locales = 27 rows)
-- ─────────────────────────────────────────────────────────────────────────────
insert into public.lesson_translations (lesson_id, locale, title, transcript) values

-- 1.1 — EN
('d1000000-0000-4000-8000-000000000001', 'en',
 'The story only you can tell',
 'Your edge isn''t a niche. It''s the story only you can credibly tell — because of your accent, your last job, your immigration story, your scars. Start by listing five things you know that most of your future customers would have to pay a consultant to learn. That isn''t bragging. It''s inventory. The point isn''t to feel special; it''s to find the place where your knowledge becomes someone else''s shortcut. Most founders pick a market first and then try to belong to it. We''re going to do it backwards. We''ll start with the moments in your life that taught you something you can''t unlearn, and work outward from there. By the end of this lesson, write down three expensive lessons — things you paid for in time, money, or pain — that you could now teach. Bring them to our first live session. That''s where your business begins.'),

-- 1.1 — ES
('d1000000-0000-4000-8000-000000000001', 'es',
 'La historia que solo tú puedes contar',
 'Tu ventaja no es un nicho. Es la historia que solo tú puedes contar con credibilidad — por tu acento, tu último trabajo, tu historia migratoria, tus cicatrices. Empieza listando cinco cosas que sabes que la mayoría de tus futuros clientes tendrían que pagar a un consultor para aprender. Eso no es presumir. Es hacer inventario. La idea no es sentirte especial; es encontrar el lugar donde tu conocimiento se convierte en el atajo de otra persona. La mayoría de los fundadores eligen un mercado primero y luego intentan pertenecer a él. Nosotros lo haremos al revés. Empezaremos por los momentos de tu vida que te enseñaron algo que ya no puedes olvidar. Al terminar esta lección, anota tres lecciones caras — cosas que pagaste con tiempo, dinero o dolor — que ahora podrías enseñar. Tráelas a la primera sesión en vivo. Ahí empieza tu negocio.'),

-- 1.1 — UR
('d1000000-0000-4000-8000-000000000001', 'ur',
 'وہ کہانی جو صرف آپ سنا سکتے ہیں',
 'آپ کی برتری کوئی نِچ نہیں۔ وہ کہانی ہے جو صرف آپ ہی یقین سے سنا سکتے ہیں — اپنے لہجے، اپنی پچھلی نوکری، ہجرت کے سفر، اور اپنے زخموں کی وجہ سے۔ پانچ چیزیں لکھیں جو آپ جانتے ہیں اور جنہیں سیکھنے کے لیے آپ کے مستقبل کے گاہکوں کو کسی مشیر کو پیسے دینے پڑیں۔ یہ شیخی نہیں، فہرست ہے۔ مقصد خاص محسوس کرنا نہیں، بلکہ یہ تلاش کرنا ہے کہ آپ کا علم کس مقام پر کسی اور کا شارٹ کٹ بنتا ہے۔ زیادہ تر بانی پہلے مارکیٹ چنتے ہیں اور پھر اس میں فٹ ہونے کی کوشش کرتے ہیں۔ ہم اس کے برعکس کریں گے۔ اس سبق کے آخر تک تین "مہنگے اسباق" لکھ لیں — وہ چیزیں جو آپ نے وقت، پیسے یا تکلیف کی صورت میں ادا کیں — جو آپ اب سکھا سکتے ہیں۔'),

-- 1.2 — EN
('d1000000-0000-4000-8000-000000000002', 'en',
 'Permission to be specific',
 'Every entrepreneur I''ve worked with makes the same first mistake: trying to be useful to everyone. Specificity isn''t a marketing tactic. It''s an act of respect. When you name your customer precisely — the second-generation immigrant accountant who wants to go solo but has a family to feed — you give them permission to feel seen. Vague brands signal "I will not commit to you." Today, write a one-sentence description of your one customer. Not a demographic. A person. Include their job, their fear, and the thing they whisper to themselves at 11pm when they should be sleeping. If you can''t write that sentence yet, that is the lesson. Your edge isn''t your skill. Your edge is being legible to one specific person before anyone else is. Specific is a magnet. Vague is wallpaper. Pick magnet, every time.'),

-- 1.2 — ES
('d1000000-0000-4000-8000-000000000002', 'es',
 'Permiso para ser específico',
 'Todo emprendedor con el que he trabajado comete el mismo primer error: intentar serle útil a todo el mundo. La especificidad no es una táctica de marketing. Es un acto de respeto. Cuando nombras a tu cliente con precisión — el contador inmigrante de segunda generación que quiere independizarse pero tiene una familia que mantener — le das permiso para sentirse visto. Las marcas vagas dicen "no me voy a comprometer contigo." Hoy escribe una frase que describa a tu único cliente. No un perfil demográfico. Una persona. Incluye su trabajo, su miedo, y eso que se susurra a sí mismo a las 11 de la noche cuando debería estar durmiendo. Si todavía no puedes escribir esa frase, esa es la lección. Tu ventaja no es tu habilidad. Tu ventaja es ser legible para una persona específica antes que cualquier otra marca.'),

-- 1.2 — UR
('d1000000-0000-4000-8000-000000000002', 'ur',
 'مخصوص ہونے کی اجازت',
 'ہر کاروباری شخص جس کے ساتھ میں نے کام کیا ہے، شروع میں یہی غلطی کرتا ہے: سب کے لیے مفید بننے کی کوشش۔ مخصوص ہونا کوئی مارکیٹنگ کی چال نہیں، یہ احترام کا اظہار ہے۔ جب آپ اپنے گاہک کا نام درست طور پر لیتے ہیں — وہ دوسری نسل کا تارکِ وطن اکاؤنٹنٹ جو خود کا کاروبار شروع کرنا چاہتا ہے لیکن خاندان پالتا ہے — تو اسے دیکھا محسوس کرنے کی اجازت دیتے ہیں۔ مبہم برانڈز یہ کہتے ہیں کہ "میں آپ سے وابستہ نہیں ہوں گا۔" آج اپنے ایک گاہک کی ایک جملے میں تفصیل لکھیں۔ آبادیاتی پروفائل نہیں، ایک حقیقی شخص۔ ان کا کام، خوف، اور وہ بات شامل کریں جو وہ رات گیارہ بجے خود سے کہتے ہیں جب سونا چاہیے۔ اگر یہ جملہ ابھی نہیں لکھ سکتے، یہی سبق ہے۔'),

-- 1.3 — EN
('d1000000-0000-4000-8000-000000000003', 'en',
 'What you stop doing',
 'A business is defined more by what it refuses than by what it offers. Side hustlers fail because they take every gig. New founders fail because they say yes to every customer. This week your job is to write a stop-doing list. What kinds of work will you decline? What kinds of clients will you not chase? What kinds of advice will you ignore? A clear refusal is a more powerful brand statement than any tagline. The goal isn''t to be exclusive — it''s to be honest. When you stop pretending to serve everyone, the people you can actually help finally find you. Bring your stop-doing list to the live session. We''ll workshop it together, line by line, until what remains is so specific it almost embarrasses you. That embarrassment is the brand. That embarrassment is the moat.'),

-- 1.3 — ES
('d1000000-0000-4000-8000-000000000003', 'es',
 'Lo que dejas de hacer',
 'Un negocio se define más por lo que rechaza que por lo que ofrece. Los side hustlers fracasan porque aceptan cualquier proyecto. Los fundadores nuevos fracasan porque le dicen sí a cada cliente. Esta semana tu tarea es escribir una lista de "qué dejar de hacer". ¿Qué tipo de trabajos vas a rechazar? ¿A qué tipo de cliente no vas a perseguir? ¿Qué tipo de consejo vas a ignorar? Un rechazo claro es una declaración de marca más potente que cualquier eslogan. La idea no es ser exclusivo, es ser honesto. Cuando dejas de fingir que sirves a todos, las personas a las que realmente puedes ayudar por fin te encuentran. Trae tu lista a la sesión en vivo. La trabajaremos juntos, línea por línea, hasta que lo que quede sea tan específico que casi te avergüence. Esa vergüenza es la marca.'),

-- 1.3 — UR
('d1000000-0000-4000-8000-000000000003', 'ur',
 'وہ کام جو آپ چھوڑ دیتے ہیں',
 'کاروبار کی پہچان اُن چیزوں سے زیادہ ہوتی ہے جنہیں وہ مسترد کرتا ہے، اُن سے کم جو وہ پیش کرتا ہے۔ سائڈ ہسلر اس لیے ناکام ہوتے ہیں کہ وہ ہر کام لے لیتے ہیں۔ نئے بانی اس لیے ناکام ہوتے ہیں کہ وہ ہر گاہک کو ہاں کہتے ہیں۔ اس ہفتے آپ کا کام ایک ایسی فہرست بنانا ہے کہ "اب یہ کام نہیں کرنا"۔ کس قسم کے کام مسترد کریں گے؟ کن گاہکوں کے پیچھے نہیں بھاگیں گے؟ کس قسم کے مشورے نظر انداز کریں گے؟ صاف انکار کسی بھی نعرے سے زیادہ مضبوط برانڈ بیان ہے۔ مقصد خاص بننا نہیں بلکہ ایماندار ہونا ہے۔ جب آپ سب کو خوش کرنے کا ڈرامہ بند کر دیتے ہیں، تو وہ لوگ آپ کو ڈھونڈ نکالتے ہیں جنہیں آپ واقعی مدد دے سکتے ہیں۔'),

-- 2.1 — EN
('d1000000-0000-4000-8000-000000000004', 'en',
 'Sell it before you build it',
 'The most expensive thing in entrepreneurship isn''t a bad product. It''s a good product nobody wants. Validation isn''t a survey. It''s a transaction. This week you''ll write a one-page offer for the thing you might build, and you''ll ask three real humans to pre-pay for it. If they say yes, you have a business. If they say no but ask follow-up questions, you have a lead. If they say no and walk away, you''ve saved yourself a year. The point isn''t to collect money — though if money arrives, deposit it. The point is to learn what people will trade their attention for. I''ll show you the exact script I used for my first paying customer, line by line, including the awkward pause where I almost backed out. If I could do it as a tired immigrant in 2014, you can do it now.'),

-- 2.1 — ES
('d1000000-0000-4000-8000-000000000004', 'es',
 'Véndelo antes de construirlo',
 'Lo más caro en el emprendimiento no es un mal producto. Es un buen producto que nadie quiere. La validación no es una encuesta. Es una transacción. Esta semana escribirás una oferta de una página para lo que podrías construir, y le pedirás a tres personas reales que paguen por adelantado. Si dicen sí, tienes un negocio. Si dicen no pero hacen más preguntas, tienes un prospecto. Si dicen no y se van, te ahorraste un año. La idea no es cobrar dinero — aunque si llega, deposítalo. La idea es aprender qué cosa la gente cambia por su atención. Te enseñaré el guion exacto que usé con mi primer cliente, línea por línea, incluyendo la pausa incómoda donde casi me echo atrás. Si yo pude hacerlo como inmigrante agotada en 2014, tú puedes hoy.'),

-- 2.1 — UR
('d1000000-0000-4000-8000-000000000004', 'ur',
 'بنانے سے پہلے بیچ دیں',
 'کاروبار میں سب سے مہنگی چیز خراب پروڈکٹ نہیں۔ سب سے مہنگی چیز ایک اچھی پروڈکٹ ہے جس کی کسی کو ضرورت نہیں۔ توثیق سروے نہیں، لین دین ہے۔ اس ہفتے ایک صفحہ کی پیشکش لکھیں اُس چیز کے لیے جو آپ بنانا چاہتے ہیں، اور تین حقیقی لوگوں سے کہیں کہ پہلے ہی ادائیگی کر دیں۔ ہاں کہا تو کاروبار ہے۔ نہ کہا مگر سوال کیے تو رابطہ ہے۔ نہ کہا اور چلے گئے تو آپ نے ایک سال بچا لیا۔ مقصد پیسے جمع کرنا نہیں — اگر آ جائیں تو رکھ لیں — مقصد یہ جاننا ہے کہ لوگ اپنی توجہ کس چیز کے بدلے دیتے ہیں۔ میں آپ کو وہ اسکرپٹ سکھاؤں گی جو میں نے اپنے پہلے گاہک کے لیے استعمال کیا تھا۔'),

-- 2.2 — EN
('d1000000-0000-4000-8000-000000000005', 'en',
 'The five conversations',
 'Before you write a single line of code, run an ad, or hire anyone, you owe yourself five conversations. Not interviews. Not customer development calls. Five honest conversations with people who fit your ideal customer description. The structure is simple: ask them about the last time they tried to solve the problem you''re addressing, and shut up. Don''t pitch. Don''t validate. Just listen for the words they use, the workarounds they''ve built, and the moment they gave up. Bring back two pages of notes per conversation. We''ll mine them together for the language that will eventually go on your landing page. The conversations themselves are the research; the transcripts are the product. Most founders skip this step because it feels too slow. That''s exactly why the founders who do it have a permanent advantage.'),

-- 2.2 — ES
('d1000000-0000-4000-8000-000000000005', 'es',
 'Las cinco conversaciones',
 'Antes de escribir una sola línea de código, lanzar un anuncio o contratar a nadie, te debes a ti mismo cinco conversaciones. No entrevistas. No llamadas de "customer development". Cinco conversaciones honestas con personas que encajan en tu cliente ideal. La estructura es simple: pregúntales sobre la última vez que intentaron resolver el problema que estás abordando, y cállate. No vendas. No valides. Solo escucha las palabras que usan, los apaños que han inventado, y el momento en que se rindieron. Trae dos páginas de notas por conversación. Las trabajaremos juntos para encontrar el lenguaje que terminará en tu landing page. Las conversaciones son la investigación; las transcripciones son el producto. La mayoría de los fundadores se saltan este paso porque les parece lento. Por eso los que lo hacen tienen ventaja permanente.'),

-- 2.2 — UR
('d1000000-0000-4000-8000-000000000005', 'ur',
 'پانچ گفتگوئیں',
 'ایک لائن کوڈ لکھنے، اشتہار چلانے یا کسی کو ملازم رکھنے سے پہلے، آپ خود سے پانچ گفتگوؤں کے قرض دار ہیں۔ یہ انٹرویو نہیں، نہ کسٹمر ڈیولپمنٹ کالز ہیں۔ یہ پانچ مخلص گفتگوئیں ہیں اُن لوگوں سے جو آپ کے مثالی گاہک سے ملتے ہیں۔ ساخت سادہ ہے: ان سے پوچھیں کہ پچھلی بار جب انہوں نے اس مسئلے کو حل کرنے کی کوشش کی تھی تو کیا ہوا تھا، اور پھر چپ ہو جائیں۔ نہ پچ کریں، نہ توثیق کریں۔ بس وہ الفاظ سنیں جو وہ استعمال کرتے ہیں، وہ کام چلاؤ حل جو انہوں نے بنائے، اور وہ لمحہ جب انہوں نے ہار مان لی۔ ہر گفتگو سے دو صفحے نوٹس لائیں۔ گفتگوئیں خود تحقیق ہیں؛ ٹرانسکرپٹ پروڈکٹ ہیں۔'),

-- 2.3 — EN
('d1000000-0000-4000-8000-000000000006', 'en',
 'The smallest possible test',
 'Your first product isn''t a product. It''s a test. A one-page Notion doc. A Calendly link. A spreadsheet. A 20-minute Loom video. Pick the smallest artifact you can put in front of someone and learn whether they''d hand over money. Then build only what that test proves. The goal of this lesson isn''t to teach you no-code tools; the internet is drowning in those. The goal is to dismantle the belief that you need to build for six months before you can charge for anything. Charge now. Deliver manually. Automate later. Founding members of this program will be invited to a live demo where I''ll build a pre-sales page from scratch in 45 minutes — using the same Notion-and-Stripe stack I used for my first $10k month. You will not need permission. You will need a deadline.'),

-- 2.3 — ES
('d1000000-0000-4000-8000-000000000006', 'es',
 'La prueba más pequeña posible',
 'Tu primer producto no es un producto. Es una prueba. Un documento de Notion de una página. Un link de Calendly. Una hoja de cálculo. Un video Loom de 20 minutos. Elige el artefacto más pequeño que puedas poner frente a alguien para aprender si entregaría dinero. Luego construye solo lo que esa prueba demuestre. El objetivo de esta lección no es enseñarte herramientas no-code; el internet está saturado de eso. El objetivo es desmontar la creencia de que tienes que construir seis meses antes de poder cobrar. Cobra ahora. Entrega a mano. Automatiza después. Los miembros fundadores serán invitados a una demo en vivo donde construiré una página de preventa desde cero en 45 minutos, usando el mismo Notion-y-Stripe con el que tuve mi primer mes de diez mil dólares.'),

-- 2.3 — UR
('d1000000-0000-4000-8000-000000000006', 'ur',
 'ممکنہ سب سے چھوٹا تجربہ',
 'آپ کی پہلی پروڈکٹ پروڈکٹ نہیں، ایک ٹیسٹ ہے۔ ایک صفحے کا نوشن دستاویز۔ ایک کیلنڈلی لنک۔ ایک اسپریڈ شیٹ۔ بیس منٹ کا لوم ویڈیو۔ سب سے چھوٹی چیز چنیں جو آپ کسی کے سامنے رکھ کر یہ سیکھ سکیں کہ کیا وہ پیسے دے گا۔ پھر صرف وہی بنائیں جو ٹیسٹ ثابت کرتا ہے۔ اس سبق کا مقصد آپ کو نو-کوڈ ٹولز سکھانا نہیں؛ انٹرنیٹ ان سے بھرا ہوا ہے۔ مقصد اُس عقیدے کو توڑنا ہے کہ آپ کو پیسے لینے سے پہلے چھ مہینے کچھ بنانا ہوگا۔ ابھی چارج کریں۔ ہاتھ سے ڈلیور کریں۔ آٹومیشن بعد میں۔ بانی اراکین کو لائیو ڈیمو میں دعوت دی جائے گی جہاں میں پینتالیس منٹ میں صفر سے پری سیلز پیج بناؤں گی۔'),

-- 3.1 — EN
('d1000000-0000-4000-8000-000000000007', 'en',
 'Where your first ten customers live',
 'They are not on TikTok. They are not coming from SEO. Your first ten customers come from your phone contacts, your alumni Slack, the WhatsApp group for your old church, and the one neighbor whose opinion you trust. Today''s task: write down fifty names. Don''t qualify them. Don''t worry about whether they need what you''re building. The list is the asset. Tomorrow, we''ll narrow it. The day after, we''ll write the message. By the end of the week, you''ll have sent it. Most founders skip this step because it''s humiliating. That is exactly why it works — anyone who''ll write a message they''re afraid to send is already ahead of 90% of the field. Bring your fifty names to the live call. We''ll do the second pass together. No one gets to skip this part. Not even me.'),

-- 3.1 — ES
('d1000000-0000-4000-8000-000000000007', 'es',
 'Dónde viven tus primeros diez clientes',
 'No están en TikTok. No vienen del SEO. Tus primeros diez clientes salen de tus contactos del teléfono, del Slack de tu universidad, del grupo de WhatsApp de tu antigua iglesia, y de ese vecino cuya opinión respetas. La tarea de hoy: escribe cincuenta nombres. No los califiques. No te preocupes por si necesitan lo que estás construyendo. La lista es el activo. Mañana la reduciremos. Pasado mañana escribiremos el mensaje. Para el fin de semana lo habrás enviado. La mayoría de los fundadores se saltan este paso porque es humillante. Por eso funciona — quien se atreve a enviar un mensaje que le da vergüenza ya está adelante del noventa por ciento. Trae tus cincuenta nombres a la sesión en vivo. Haremos el segundo filtro juntos. Nadie se salta esta parte. Yo tampoco.'),

-- 3.1 — UR
('d1000000-0000-4000-8000-000000000007', 'ur',
 'آپ کے پہلے دس گاہک کہاں رہتے ہیں',
 'وہ ٹک ٹاک پر نہیں۔ وہ SEO سے نہیں آ رہے۔ آپ کے پہلے دس گاہک آپ کے فون رابطوں، پرانے یونیورسٹی سلیک، پرانی مسجد کے واٹس ایپ گروپ، اور اُس ایک پڑوسی سے آتے ہیں جس کی رائے پر آپ اعتماد کرتے ہیں۔ آج کا کام: پچاس نام لکھیں۔ انہیں جانچیں نہیں۔ یہ نہ سوچیں کہ انہیں آپ کی پروڈکٹ کی ضرورت ہے یا نہیں۔ فہرست ہی اثاثہ ہے۔ کل اسے تنگ کریں گے۔ پرسوں پیغام لکھیں گے۔ ہفتے کے آخر تک آپ نے بھیج دیا ہوگا۔ زیادہ تر بانی یہ مرحلہ چھوڑ دیتے ہیں کیونکہ یہ شرمندہ کرنے والا ہے۔ اسی لیے یہ کام کرتا ہے — جو شخص ایسا پیغام بھیجے گا جس سے ڈر لگتا ہو، وہ پہلے ہی نوے فیصد سے آگے ہے۔'),

-- 3.2 — EN
('d1000000-0000-4000-8000-000000000008', 'en',
 'Write the message they''ll reply to',
 'Cold outreach isn''t a numbers game. It''s a craft. The message that works is short, names the recipient''s specific situation, makes a concrete ask, and ends with an out. It doesn''t sell. It invites. We''ll workshop three openers in this lesson: the alumni opener, the parent-of-a-kid-in-your-kid''s-school opener, and the LinkedIn opener. Each one is calibrated for a different kind of relationship. Don''t copy them verbatim — your fingerprints are the whole point — but use them as scaffolding. By Friday, send ten messages. Track the reply rate, not the close rate. Replies tell you whether your message landed. Closes tell you whether the offer landed. We''re optimizing the former this week, and we''ll come back to the latter next week. Volume is not the cure for a bad message; specificity is.'),

-- 3.2 — ES
('d1000000-0000-4000-8000-000000000008', 'es',
 'Escribe el mensaje al que sí responden',
 'El outreach en frío no es un juego de volumen. Es un oficio. El mensaje que funciona es corto, nombra la situación específica del destinatario, hace una petición concreta y termina con una salida. No vende. Invita. Trabajaremos tres aperturas en esta lección: la de exalumnos, la de "padre del compañero de mi hijo en la escuela", y la de LinkedIn. Cada una está calibrada para un tipo de relación. No las copies textualmente — tus huellas son la clave — pero úsalas como andamio. Para el viernes, envía diez mensajes. Mide la tasa de respuesta, no la de cierre. Las respuestas te dicen si el mensaje aterrizó. Los cierres te dicen si la oferta aterrizó. Esta semana optimizamos la respuesta. El volumen no cura un mensaje malo; la especificidad sí.'),

-- 3.2 — UR
('d1000000-0000-4000-8000-000000000008', 'ur',
 'وہ پیغام لکھیں جس کا جواب آئے',
 'کولڈ آؤٹ ریچ نمبروں کا کھیل نہیں، ایک ہنر ہے۔ موثر پیغام مختصر ہوتا ہے، وصول کنندہ کی مخصوص صورتحال کا ذکر کرتا ہے، ایک واضح درخواست رکھتا ہے، اور انکار کا راستہ کھلا چھوڑتا ہے۔ یہ بیچتا نہیں، بلاتا ہے۔ اس سبق میں ہم تین اوپنر پر کام کریں گے: ایلومنائی اوپنر، اپنے بچے کے اسکول والے بچے کے والد کا اوپنر، اور لنکڈ اِن اوپنر۔ ہر ایک مختلف رشتے کے لیے بنا ہے۔ انہیں نقل نہ کریں — آپ کے دستخط ہی اصل ہیں — انہیں ڈھانچے کے طور پر استعمال کریں۔ جمعہ تک دس پیغامات بھیجیں۔ جواب کی شرح ناپیں، بکنے کی نہیں۔ خاص ہونا، نہ کہ زیادہ بھیجنا، خراب پیغام کا علاج ہے۔'),

-- 3.3 — EN
('d1000000-0000-4000-8000-000000000009', 'en',
 'Charging more than feels comfortable',
 'Your first price should make you slightly nauseous. If you can quote it without flinching, it''s too low. We''re going to walk through the pricing conversation step by step: how to anchor, how to handle the "that''s a lot" objection, when to discount and when to walk, and the exact words I use to close. Pricing isn''t math. It''s belief. The first customer to pay your uncomfortable price isn''t paying for the product. They''re paying for the conviction that what you''re building deserves to exist. Bring your draft price to the live session and we''ll stress-test it together. By the end of next week, you''ll have your first paying customer or a clear reason why you don''t. Either outcome is a win. The only failure mode is staying in a price-quoting hypothetical longer than the week we have together.'),

-- 3.3 — ES
('d1000000-0000-4000-8000-000000000009', 'es',
 'Cobrar más de lo que se siente cómodo',
 'Tu primer precio debería darte un poco de náuseas. Si lo dices sin pestañear, está demasiado bajo. Recorreremos la conversación de precios paso a paso: cómo anclar, cómo manejar la objeción "es mucho", cuándo dar descuento y cuándo retirarse, y las palabras exactas que uso para cerrar. El precio no es matemática. Es creencia. El primer cliente que paga tu precio incómodo no está pagando por el producto. Está pagando por la convicción de que lo que estás construyendo merece existir. Trae tu precio borrador a la sesión en vivo y lo pondremos a prueba juntos. Para el final de la próxima semana, tendrás tu primer cliente que paga o una razón clara de por qué no. Cualquiera de los dos es victoria. Lo único que no se permite es quedarte en hipótesis.'),

-- 3.3 — UR
('d1000000-0000-4000-8000-000000000009', 'ur',
 'اس سے زیادہ چارج کریں جتنا آرام دہ لگے',
 'آپ کی پہلی قیمت آپ کو ہلکی متلی محسوس کرانی چاہیے۔ اگر آپ بنا رکے قیمت بتا دیں، تو وہ بہت کم ہے۔ ہم قدم بہ قدم قیمت کی گفتگو پر چلیں گے: کیسے اینکر کریں، "یہ تو بہت زیادہ ہے" والے اعتراض کا جواب کیسے دیں، کب رعایت دیں اور کب چھوڑ دیں، اور وہ الفاظ جو میں سودا طے کرتے وقت استعمال کرتی ہوں۔ قیمت گنتی نہیں، یقین ہے۔ آپ کی غیر آرام دہ قیمت پر ادائیگی کرنے والا پہلا گاہک پروڈکٹ کی قیمت نہیں دے رہا، بلکہ اِس یقین کی قیمت دے رہا ہے کہ آپ جو بنا رہے ہیں اسے وجود کا حق ہے۔ اگلی ہفتے کے آخر تک، آپ کا پہلا ادا کرنے والا گاہک ہوگا یا ایک واضح وجہ ہوگی کہ کیوں نہیں۔')

on conflict (lesson_id, locale) do update set
  title = excluded.title,
  transcript = excluded.transcript;
