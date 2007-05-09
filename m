From: akpm@linux-foundation.org
Subject: - vt-add-documentation-for-new-boot-sysfs-options.patch removed from -mm tree
Date: Tue, 08 May 2007 20:01:10 -0700
Message-ID: <200705090301.l4931ALb010658@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033025AbXEIDBN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 23:01:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adaplas@gmail.com, mm-commits@vger.kernel.org


The patch titled
     vt: add documentation for new boot/sysfs options
has been removed from the -mm tree.  Its filename was
     vt-add-documentation-for-new-boot-sysfs-options.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vt: add documentation for new boot/sysfs options
From: "Antonino A. Daplas" <adaplas@gmail.com>

Add description to Documentation/kernel-parameters.txt on new options
default_blue, default_grn, default_red, and default_utf8.

Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN Documentation/kernel-parameters.txt~vt-add-documentation-for-new-boot-sysfs-options Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~vt-add-documentation-for-new-boot-sysfs-options
+++ a/Documentation/kernel-parameters.txt
@@ -496,6 +496,30 @@ and is between 256 and 4096 characters. 
 			Format: <area>[,<node>]
 			See also Documentation/networking/decnet.txt.
 
+	default_blu=	[VT]
+			Format: <blue0>,<blue1>,<blue2>,...,<blue15>
+			Change the default blue palette of the console.
+			This is a 16-member array composed of values
+			ranging from 0-255.
+
+	default_grn=	[VT]
+			Format: <green0>,<green1>,<green2>,...,<green15>
+			Change the default green palette of the console.
+			This is a 16-member array composed of values
+			ranging from 0-255.
+
+	default_red=	[VT]
+			Format: <red0>,<red1>,<red2>,...,<red15>
+			Change the default red palette of the console.
+			This is a 16-member array composed of values
+			ranging from 0-255.
+
+	default_utf8=   [VT]
+			Format=<0|1>
+			Set system-wide default UTF-8 mode for all tty's.
+			Default is 0 and by setting to 1, it enables UTF-8
+			mode for all newly opened or allocated terminals.
+
 	dhash_entries=	[KNL]
 			Set number of hash buckets for dentry cache.
 
_

Patches currently in -mm which might be from adaplas@gmail.com are

origin.patch
vt8623fb-new-framebuffer-driver-for-via-vt8623.patch
vt8623fb-fix-compile-warnings.patch
vt8623fb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards.patch
arkfb-fix-compiler-warnings.patch
arkfb-fix-compile-error-if-config_mtrr=n.patch
arkfb-new-framebuffer-driver-for-ark-logic-cards-fix.patch
svgalib-move-fb_get_caps-to-svgalib.patch
