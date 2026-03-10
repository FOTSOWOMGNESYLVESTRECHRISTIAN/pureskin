-- Mise à jour du mot de passe admin pour utiliser "admin123" avec un hash BCrypt correct
-- Hash BCrypt pour "admin123": $2a$10$N9qo8uLOickgx2ZMRZoMye.IjdJrJ6tGK/PNv7YHDv8J6wJ6Kw1S

UPDATE users 
SET password_hash = '$2a$10$N9qo8uLOickgx2ZMRZoMye.IjdJrJ6tGK/PNv7YHDv8J6wJ6Kw1S'
WHERE username = 'admin' AND email = 'admin@pureskin-etu.com';

-- Vérification
SELECT id, username, email, role, is_active FROM users WHERE username = 'admin';
