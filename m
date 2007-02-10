From: akpm@linux-foundation.org
Subject: - toshiba-acpi-use-array_size-macro-when-appropriate.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:23:27 -0800
Message-ID: <200702100523.l1A5NRuH004528@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36708 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbXBJFY4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:24:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: darwish.07@gmail.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     toshiba-acpi: Use ARRAY_SIZE macro when appropriate
has been removed from the -mm tree.  Its filename was
     toshiba-acpi-use-array_size-macro-when-appropriate.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: toshiba-acpi: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/toshiba_acpi.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/toshiba_acpi.c~toshiba-acpi-use-array_size-macro-when-appropriate drivers/acpi/toshiba_acpi.c
--- a/drivers/acpi/toshiba_acpi.c~toshiba-acpi-use-array_size-macro-when-appropriate
+++ a/drivers/acpi/toshiba_acpi.c
@@ -125,7 +125,7 @@ static int write_acpi_int(const char *me
 	union acpi_object in_objs[1];
 	acpi_status status;
 
-	params.count = sizeof(in_objs) / sizeof(in_objs[0]);
+	params.count = ARRAY_SIZE(in_objs);
 	params.pointer = in_objs;
 	in_objs[0].type = ACPI_TYPE_INTEGER;
 	in_objs[0].integer.value = val;
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
git-scsi-misc.patch
arch-arm26-use-array_size-macro-when-appropriate.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
arch-cris-user-array_size-macro-when-appropriate.patch
arch-v850-user-array_size-macro-when-appropriate.patch
w1-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate-2.patch
reiserfs-use-array_size-macro-when-appropriate.patch
isdn-capi-use-array_size-when-appropriate.patch
isdn-eicon-use-array_size-macro-when-appropriate.patch
rcutorture-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
