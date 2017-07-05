From: akpm@linux-foundation.org
Subject: + arm-samsung-usb-ohci-move-inline-before-return-type.patch added to -mm tree
Date: Wed, 05 Jul 2017 13:45:36 -0700
Message-ID: <595d4ff0.yZW79WzXsfRrop2C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54768 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753113AbdGEUpm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 16:45:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: samsung: usb-ohci: move inline before return type
has been added to the -mm tree.  Its filename is
     arm-samsung-usb-ohci-move-inline-before-return-type.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-samsung-usb-ohci-move-inline-before-return-type.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-samsung-usb-ohci-move-inline-before-return-type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: ARM: samsung: usb-ohci: move inline before return type

Make the code like the rest of the kernel.

Link: http://lkml.kernel.org/r/667a515b8d0f10f2465d519f8595edd91552fc5e.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/platform_data/usb-ohci-s3c2410.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/platform_data/usb-ohci-s3c2410.h~arm-samsung-usb-ohci-move-inline-before-return-type include/linux/platform_data/usb-ohci-s3c2410.h
--- a/include/linux/platform_data/usb-ohci-s3c2410.h~arm-samsung-usb-ohci-move-inline-before-return-type
+++ a/include/linux/platform_data/usb-ohci-s3c2410.h
@@ -31,7 +31,7 @@ struct s3c2410_hcd_info {
 	void		(*report_oc)(struct s3c2410_hcd_info *, int ports);
 };
 
-static void inline s3c2410_usb_report_oc(struct s3c2410_hcd_info *info, int ports)
+static inline void s3c2410_usb_report_oc(struct s3c2410_hcd_info *info, int ports)
 {
 	if (info->report_oc != NULL) {
 		(info->report_oc)(info, ports);
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
checkpatch-improve-tests-for-multiple-line-function-definitions.patch
checkpatch-improve-macro-reuse-test.patch
checkpatch-improve-multi-line-alignment-test.patch
checkpatch-improve-the-storage_class-test.patch
arm-kvm-move-asmlinkage-before-type.patch
arm-hp-jornada-7xx-move-inline-before-return-type.patch
cris-gpio-move-inline-before-return-type.patch
frv-tlbflush-move-asmlinkage-before-return-type.patch
ia64-move-inline-before-return-type.patch
ia64-sn-pci-move-inline-before-type.patch
m68k-coldfire-move-inline-before-return-type.patch
mips-smp-move-asmlinkage-before-return-type.patch
sh-move-inline-before-return-type.patch
x86-efi-move-asmlinkage-before-return-type.patch
drivers-s390-move-static-and-inline-before-return-type.patch
drivers-tty-serial-move-inline-before-return-type.patch
usb-serial-safe_serial-move-__inline__-before-return-type.patch
video-fbdev-intelfb-move-inline-before-return-type.patch
video-fbdev-omap-move-inline-before-return-type.patch
arm-samsung-usb-ohci-move-inline-before-return-type.patch
alsa-opl4-move-inline-before-return-type.patch

