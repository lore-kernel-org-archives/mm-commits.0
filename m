From: akpm@linux-foundation.org
Subject: [merged]
 maintainers-add-quotation-marks-around-names-with-commas.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:47:49 -0700
Message-ID: <5591aef5.Q5S/cQLMoIGN/jRn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbbF2Urt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:47:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: Add quotation marks around names with commas
has been removed from the -mm tree.  Its filename was
     maintainers-add-quotation-marks-around-names-with-commas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: MAINTAINERS: Add quotation marks around names with commas

This makes it easier to copy/paste names with periods to email clients.

All the other names with commas already have quotation marks.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~maintainers-add-quotation-marks-around-names-with-commas MAINTAINERS
--- a/MAINTAINERS~maintainers-add-quotation-marks-around-names-with-commas
+++ a/MAINTAINERS
@@ -2498,7 +2498,7 @@ F:	arch/powerpc/oprofile/*cell*
 F:	arch/powerpc/platforms/cell/
 
 CEPH DISTRIBUTED FILE SYSTEM CLIENT
-M:	Yan, Zheng <zyan@redhat.com>
+M:	"Yan, Zheng" <zyan@redhat.com>
 M:	Sage Weil <sage@redhat.com>
 L:	ceph-devel@vger.kernel.org
 W:	http://ceph.com/
@@ -9105,7 +9105,7 @@ F:	arch/arm/mach-davinci/
 F:	drivers/i2c/busses/i2c-davinci.c
 
 TI DAVINCI SERIES MEDIA DRIVER
-M:	Lad, Prabhakar <prabhakar.csengg@gmail.com>
+M:	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
@@ -9115,7 +9115,7 @@ F:	drivers/media/platform/davinci/
 F:	include/media/davinci/
 
 TI AM437X VPFE DRIVER
-M:	Lad, Prabhakar <prabhakar.csengg@gmail.com>
+M:	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
@@ -9124,7 +9124,7 @@ S:	Maintained
 F:	drivers/media/platform/am437x/
 
 OV2659 OMNIVISION SENSOR DRIVER
-M:	Lad, Prabhakar <prabhakar.csengg@gmail.com>
+M:	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org/
 Q:	http://patchwork.linuxtv.org/project/linux-media/list/
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch
printk-improve-the-description-of-dev-kmsg-line-format.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
maintainers-update-sound-soc-intel-patterns.patch
maintainers-update-brcm-dts-pattern.patch
maintainers-update-brcm-gpio-filename-pattern.patch
maintainers-remove-unused-nbdh-pattern.patch
maintainers-move-jens-osterkamp-to-credits.patch
maintainers-bcache-kent-overstreet-has-changed-email-address.patch

