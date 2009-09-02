From: akpm@linux-foundation.org
Subject: [merged] gspca-fix-sn9c20x-build-errors.patch removed from -mm tree
Date: Wed, 02 Sep 2009 12:08:09 -0700
Message-ID: <200909021908.n82J89Ro010092@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751425AbZIBTTh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Sep 2009 15:19:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, brijohn@gmail.com, mchehab@infradead.org, toralf.foerster@gmx.de, mm-commits@vger.kernel.org


The patch titled
     gspca: fix sn9c20x build errors
has been removed from the -mm tree.  Its filename was
     gspca-fix-sn9c20x-build-errors.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: gspca: fix sn9c20x build errors
=46rom: Randy Dunlap <randy.dunlap@oracle.com>

=46ix gscpa sn9c20x build errors:
ERROR: "input_event" [drivers/media/video/gspca/gspca_sn9c20x.ko] undef=
ined!
ERROR: "input_register_device" [drivers/media/video/gspca/gspca_sn9c20x=
=2Eko] undefined!
ERROR: "input_free_device" [drivers/media/video/gspca/gspca_sn9c20x.ko]=
 undefined!
ERROR: "input_unregister_device" [drivers/media/video/gspca/gspca_sn9c2=
0x.ko] undefined!
ERROR: "input_allocate_device" [drivers/media/video/gspca/gspca_sn9c20x=
=2Eko] undefined!

Reported-by: Toralf F=F6rster <toralf.foerster@gmx.de
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Brian Johnson <brijohn@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/gspca/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/gspca/Kconfig~gspca-fix-sn9c20x-build-err=
ors drivers/media/video/gspca/Kconfig
--- a/drivers/media/video/gspca/Kconfig~gspca-fix-sn9c20x-build-errors
+++ a/drivers/media/video/gspca/Kconfig
@@ -123,7 +123,7 @@ config USB_GSPCA_SN9C20X
=20
 config USB_GSPCA_SN9C20X_EVDEV
 	bool "Enable evdev support"
-	depends on USB_GSPCA_SN9C20X
+       depends on USB_GSPCA_SN9C20X && INPUT
 	---help---
 	  Say Y here in order to enable evdev support for sn9c20x webcam butt=
on.
=20
_

Patches currently in -mm which might be from randy.dunlap@oracle.com ar=
e

origin.patch
linux-next.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sys=
fs-interface.patch
kernel-hacking-move-strip_asm_syms-from-general.patch
mtd-make-onenand-genericc-more-generic-fix.patch
isdn-fix-netjet-build-errors.patch
scsi-fix-func-names-in-kernel-doc.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
page_alloc-fix-kernel-doc-warning.patch
ksm-add-some-documentation.patch
lis3-add-power-management-functions-fix.patch
procfs-provide-stack-information-for-threads-v011-fix.patch
spih-add-missing-kernel-doc-for-struct-spi_master.patch
gpiolib-allow-exported-gpio-nodes-to-be-named-using-sysfs-links-update-=
fix.patch
doc-filesystems-remove-smount-program.patch
doc-filesystems-more-mount-cleanups.patch
documentation-update-stale-definition-of-file-nr-in-fstxt.patch
includecheck-fix-documentation-cfag12864b-examplec.patch
reiser4-export-remove_from_page_cache-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
