From: akpm@linux-foundation.org
Subject: - byteorder-add-new-headers-for-make-headers-install.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:25 -0700
Message-ID: <200810202037.m9KKbPgf011627@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877AbYJTUiO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:38:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     byteorder: add new headers for make headers-install
has been removed from the -mm tree.  Its filename was
     byteorder-add-new-headers-for-make-headers-install.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: byteorder: add new headers for make headers-install
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/Kbuild~byteorder-add-new-headers-for-make-headers-install include/linux/Kbuild
--- a/include/linux/Kbuild~byteorder-add-new-headers-for-make-headers-install
+++ a/include/linux/Kbuild
@@ -183,6 +183,7 @@ unifdef-y += auto_fs.h
 unifdef-y += auxvec.h
 unifdef-y += binfmts.h
 unifdef-y += blktrace_api.h
+unifdef-y += byteorder.h
 unifdef-y += capability.h
 unifdef-y += capi.h
 unifdef-y += cciss_ioctl.h
@@ -340,6 +341,7 @@ unifdef-y += soundcard.h
 unifdef-y += stat.h
 unifdef-y += stddef.h
 unifdef-y += string.h
+unifdef-y += swab.h
 unifdef-y += synclink.h
 unifdef-y += sysctl.h
 unifdef-y += tcp.h
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
cifs-remove-global_extern-macro.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
scsi-remove-private-implementation-of-get_unaligned_be32.patch
usb-avoid-needless-address-taking-of-function-parameters.patch

