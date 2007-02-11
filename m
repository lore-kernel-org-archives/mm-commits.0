From: akpm@linux-foundation.org
Subject: - arch-arm26-use-array_size-macro-when-appropriate.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:47:13 -0800
Message-ID: <200702112247.l1BMlDYo015536@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59599 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932638AbXBKWrT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:47:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, spyro@f2s.com, mm-commits@vger.kernel.org


The patch titled
     ARM26: Use ARRAY_SIZE macro when appropriate
has been removed from the -mm tree.  Its filename was
     arch-arm26-use-array_size-macro-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ARM26: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in linux/kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Acked-by: Ian Molton <spyro@f2s.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm26/kernel/ecard.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/arm26/kernel/ecard.c~arch-arm26-use-array_size-macro-when-appropriate arch/arm26/kernel/ecard.c
--- a/arch/arm26/kernel/ecard.c~arch-arm26-use-array_size-macro-when-appropriate
+++ a/arch/arm26/kernel/ecard.c
@@ -665,7 +665,7 @@ ecard_probe(int slot, card_type_t type)
 		ec->fiqmask = 4;
 	}
 
-	for (i = 0; i < sizeof(blacklist) / sizeof(*blacklist); i++)
+	for (i = 0; i < ARRAY_SIZE(blacklist); i++)
 		if (blacklist[i].manufacturer == ec->cid.manufacturer &&
 		    blacklist[i].product == ec->cid.product) {
 			ec->card_desc = blacklist[i].type;
_

Patches currently in -mm which might be from darwish.07@gmail.com are

origin.patch
git-acpi.patch
git-agpgart.patch
arch-arm-use-array_size-macro-when-appropriate.patch
git-avr32.patch
git-drm.patch
git-dvb.patch
git-infiniband.patch
git-mips.patch
atm-use-array_size-macro-when-appropriate.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
s390-drivers-use-array_size-macro-when-appropriate.patch
w1-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate-2.patch
reiserfs-use-array_size-macro-when-appropriate.patch
isdn-capi-use-array_size-when-appropriate.patch
isdn-eicon-use-array_size-macro-when-appropriate.patch
rcutorture-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
