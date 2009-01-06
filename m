From: akpm@linux-foundation.org
Subject: - frv-use-the-new-byteorder-headers.patch removed from -mm tree
Date: Tue, 06 Jan 2009 15:58:44 -0800
Message-ID: <200901062358.n06NwijQ002167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756272AbZAFX7B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2009 18:59:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     frv: use the new byteorder headers
has been removed from the -mm tree.  Its filename was
     frv-use-the-new-byteorder-headers.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: use the new byteorder headers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/byteorder.h |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN include/asm-frv/byteorder.h~frv-use-the-new-byteorder-headers include/asm-frv/byteorder.h
--- a/include/asm-frv/byteorder.h~frv-use-the-new-byteorder-headers
+++ a/include/asm-frv/byteorder.h
@@ -1,13 +1,9 @@
 #ifndef _ASM_BYTEORDER_H
 #define _ASM_BYTEORDER_H
 
-#include <asm/types.h>
+#define __BIG_ENDIAN
+#define __SWAB_64_THRU_32__
 
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
-#include <linux/byteorder/big_endian.h>
+#include <linux/byteorder.h>
 
 #endif /* _ASM_BYTEORDER_H */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
alpha-use-the-new-byteorder-headers.patch
lib-fix-sparse-shadowed-variable-warning.patch
lib-radix_treec-make-percpu-variable-static.patch
lib-proportionsc-trivial-sparse-lock-annotation.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
linux-next.patch
input-ads7846c-sparse-lock-annotation.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
memstick-annotate-endianness-of-attribute-structs.patch
byteorder-add-load_-store_endian-api.patch
unaligned-consolidate-unaligned-headers-add-load_-store_endian_noalign.patch
unaligned-wire-up-trivial-arches-for-new-common-unaligned-header.patch
sh-wire-up-arch-overrides-for-unaligned-access-on-the-sh4a.patch
unaligned-wire-up-h8300-and-m32r-arches.patch
unaligned-wire-up-arm-arch-overrides-for-unaligned-access.patch
unaligned-remove-the-old-implementation.patch
ata-replace-byteshifting-with-unaligned-endian-helpers.patch
usb-use-unaligned-endian-helpers-in-storage-drivers.patch

