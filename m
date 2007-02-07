From: akpm@linux-foundation.org
Subject: + toshiba-acpi-use-array_size-macro-when-appropriate.patch added to -mm tree
Date: Tue, 06 Feb 2007 16:14:43 -0800
Message-ID: <200702070014.l170Ehje001422@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56226 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030298AbXBGAQB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 19:16:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, lenb@kernel.org


The patch titled
     toshiba-acpi: Use ARRAY_SIZE macro when appropriate
has been added to the -mm tree.  Its filename is
     toshiba-acpi-use-array_size-macro-when-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

toshiba-acpi-use-array_size-macro-when-appropriate.patch
intel-agp-use-array_size-macro-when-appropriate.patch
arch-arm-use-array_size-macro-when-appropriate.patch
arch-avr32-use-array_size-macro-when-appropriate.patch
arch-powerpc-user-array_size-macro-when-appropriate.patch
arch-ppc-user-array_size-macro-when-appropriate.patch
drm-use-array_size-macro-when-appropriate.patch
git-dvb.patch
dvb-use-array_size-macro-when-appropriate.patch
git-netdev-all.patch
atm-use-array_size-macro-when-appropriate.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
s390-drivers-use-array_size-macro-when-appropriate.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
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
