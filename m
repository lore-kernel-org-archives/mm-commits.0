From: akpm@linux-foundation.org
Subject: - drivers-input-keyboard-atkbdc-make-forced_release_keys-static.patch removed from -mm tree
Date: Mon, 12 Jan 2009 11:58:22 -0800
Message-ID: <200901121958.n0CJwM4Z027505@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755787AbZALT7F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 14:59:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: impulze@impulze.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     drivers/input/keyboard/atkbd.c: make forced_release_keys[] static
has been removed from the -mm tree.  Its filename was
     drivers-input-keyboard-atkbdc-make-forced_release_keys-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/input/keyboard/atkbd.c: make forced_release_keys[] static
From: Daniel Mierswa <impulze@impulze.org>

Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/atkbd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/input/keyboard/atkbd.c~drivers-input-keyboard-atkbdc-make-forced_release_keys-static drivers/input/keyboard/atkbd.c
--- a/drivers/input/keyboard/atkbd.c~drivers-input-keyboard-atkbdc-make-forced_release_keys-static
+++ a/drivers/input/keyboard/atkbd.c
@@ -852,7 +852,7 @@ static void atkbd_gen_release_event(stru
  */
 static void atkbd_dell_laptop_keymap_fixup(struct atkbd *atkbd)
 {
-	const unsigned int forced_release_keys[] = {
+	static const unsigned int forced_release_keys[] = {
 		0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8f, 0x93,
 	};
 
@@ -866,7 +866,7 @@ static void atkbd_dell_laptop_keymap_fix
  */
 static void atkbd_hp_keymap_fixup(struct atkbd *atkbd)
 {
-	const unsigned int forced_release_keys[] = {
+	static const unsigned int forced_release_keys[] = {
 		0x94,
 	};
 
_

Patches currently in -mm which might be from impulze@impulze.org are

linux-next.patch
drivers-input-keyboard-atkbdc-use-function-for-generation-of-keyrelease-events.patch
drivers-input-keyboard-atkbdc-fujitsu-siemens-amilo-pa-1510-quirks.patch

