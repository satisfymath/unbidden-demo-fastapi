-- The demo's production data: 2,000 customers who can sign in (password: demo-password) and 200,000 items.
-- Declared as a seed: this is staged data on a copy of an open-source template.
INSERT INTO "user" (id, email, is_active, is_superuser, full_name, hashed_password, created_at)
SELECT gen_random_uuid(), 'customer' || g.i || '@example.com', true, false, 'Customer ' || g.i,
       '$2b$12$Cys2hp0lxCpRjrcmv2NQXeXQ2Zfa7eIcOvgCAPoEfYj6B1//RnCJG', now()
FROM generate_series(1, 2000) AS g(i)
ON CONFLICT DO NOTHING;

WITH owners AS (SELECT id, row_number() OVER (ORDER BY email) AS n FROM "user" WHERE email LIKE 'customer%')
INSERT INTO item (id, title, description, owner_id, created_at)
SELECT gen_random_uuid(),
       (ARRAY['Review the contract', 'Call the supplier', 'Update the roadmap', 'Prepare the invoice',
              'Fix the checkout copy', 'Plan the release', 'Answer the survey', 'Book the venue'])[1 + g.i % 8]
         || ' #' || g.i,
       'Seeded for the demo', o.id, now() - (g.i || ' seconds')::interval
FROM generate_series(1, 200000) AS g(i)
JOIN owners o ON o.n = 1 + (g.i % 2000);

ANALYZE "user";
ANALYZE item;
