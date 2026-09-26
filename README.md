# POUL COLLECTIONS — Modern Fashion Storefront

A luxury fashion storefront and studio inventory system for bespoke suits and polos.

**No Node.js, npm, or local computer server is required.** The entire website runs as pure, standard HTML, CSS, and Vanilla JavaScript, connected directly to a cloud database and cloud image storage.

---

## 🚀 Key Highlights

- **Pure HTML/CSS/JS**: Open `index.html` directly in your browser. No build steps, no webpack, no local Node.js server required.
- **Identical Visual Design**: Pixel-perfect layout, Cormorant Garamond / DM Sans typography, bespoke color palette, responsive grid, fabric cards, and WhatsApp integration.
- **Serverless Cloud Database (Supabase)**: Products, titles, descriptions, categories, and prices are stored in cloud-hosted PostgreSQL, independent of your computer.
- **Cloud Image Storage**: High-resolution photography is uploaded directly from the browser to Supabase Cloud Storage (S3-compatible CDN).
- **Admin Workspace (`admin.html`)**: Password-protected studio dashboard to upload new pieces, set prices, upload photography, and manage live inventory.

---

## 📁 Project Structure

```text
├── index.html              # Main public storefront (Collection, Delivery, Enquire)
├── admin.html              # Studio admin workspace (Uploads & inventory management)
├── favicon.ico             # Studio favicon
├── css/
│   └── style.css           # Complete vanilla stylesheet & design tokens
├── js/
│   ├── config.js           # Supabase & studio configuration
│   ├── db.js               # Cloud database & storage client
│   ├── app.js              # Storefront catalog & filtering logic
│   └── admin.js            # Admin workspace & direct image uploader
├── supabase-setup.sql      # 1-click database & storage bucket setup script
└── vercel.json             # Static deployment configuration
```

---

## ⚡ How to Run Locally

You do not need to install or run Node.js.
1. Simply double-click **`index.html`** in Windows Explorer or open it with any web browser (Chrome, Edge, Firefox, Safari).
2. To manage inventory or add products, open **`admin.html`**.
   - Default Admin Password: `VelPoul@25BT?`

---

## ☁️ Connecting Your Cloud Database (Supabase)

To make your database and image storage completely independent of your computer (24/7 cloud availability):

### Step 1: Create a Free Supabase Project
1. Visit [supabase.com](https://supabase.com) and create a free account.
2. Click **New Project**, choose a name (e.g. `poul-collections`) and set a database password.

### Step 2: Run the Setup Script
1. In your Supabase project dashboard, click **SQL Editor** on the left menu.
2. Open the file **[`supabase-setup.sql`](./supabase-setup.sql)** from this repository, copy its entire contents, paste it into the SQL Editor, and click **Run**.
3. This creates:
   - The `products` table with all fields.
   - The `product-images` cloud storage bucket for photography.
   - Security policies allowing public viewing and admin uploads.
   - Starter suits and polos.

### Step 3: Connect the Storefront
1. In your Supabase dashboard, navigate to **Project Settings &rarr; API**.
2. Copy your **Project URL** (e.g. `https://xyzabc.supabase.co`) and **Project API Key (anon / public)**.
3. Open `admin.html` in your browser, log in, click **⚙ Cloud DB Settings**, paste your URL and Anon Key, and click **Save Settings**.
   - *Alternatively, paste them directly into [`js/config.js`](./js/config.js).*
4. Click **Test Connection** — you will see `● Supabase Cloud Connected`!

Admin settings are saved only in the current browser. To connect the deployed storefront for all visitors, set `PUBLIC_SUPABASE_URL` and `PUBLIC_SUPABASE_ANON_KEY` in [`js/config.js`](./js/config.js) to your Supabase Project URL and public anon key. The anon key is intended for browser use; protect data with Supabase RLS policies.

All new suits, polos, and photos you add will now be stored in the cloud.

### Step 4: Enable live storefront updates
The setup script also adds `public.products` to Supabase's `supabase_realtime` publication. Run [`supabase-setup.sql`](./supabase-setup.sql) in **Supabase Dashboard &rarr; SQL Editor**; the publication step is safe to run again. The storefront listens for inserts, edits, and deletions, then reloads the currently selected category without requiring visitors to refresh. Live updates require the public Supabase settings above to be configured in the deployed site.

---

## 🌐 Free Hosting Options

Because this site is 100% static HTML:

- **GitHub Pages**:
  Push this repository to GitHub, go to **Settings &rarr; Pages**, choose **GitHub Actions**, and it deploys automatically.
- **Vercel**:
  Import the repository on [Vercel](https://vercel.com). It detects static files and deploys instantly.
- **Netlify / Cloudflare Pages**:
  Drag and drop the folder or connect your Git repo for instant global CDN hosting.

---

## 🔒 Security & Admin Details

- **Admin Password**: Configured in [`js/config.js`](./js/config.js) or updated via the Admin Workspace UI.
- **Image Uploads**: Restricted to JPEG, PNG, and WebP formats up to 10MB each.
- **Contact & WhatsApp**: Enquiries route directly to `+254 787 764 095`.
