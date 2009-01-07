From: akpm@linux-foundation.org
Subject: - docs-document-how-to-write-varargs-in-kernel-doc.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:20:07 -0800
Message-ID: <200901072220.n07MK73Y019372@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763308AbZAGWgx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:36:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     docs: document how to write @varargs in kernel-doc
has been removed from the -mm tree.  Its filename was
     docs-document-how-to-write-varargs-in-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: docs: document how to write @varargs in kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

Add documentation on how to use kernel-doc for function parameters
that are "..." (varargs).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-doc-nano-HOWTO.txt |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN Documentation/kernel-doc-nano-HOWTO.txt~docs-document-how-to-write-varargs-in-kernel-doc Documentation/kernel-doc-nano-HOWTO.txt
--- a/Documentation/kernel-doc-nano-HOWTO.txt~docs-document-how-to-write-varargs-in-kernel-doc
+++ a/Documentation/kernel-doc-nano-HOWTO.txt
@@ -71,6 +71,11 @@ The @argument descriptions must begin on
 this opening short function description line, with no intervening
 empty comment lines.
 
+If a function parameter is "..." (varargs), it should be listed in
+kernel-doc notation as:
+ * @...: description
+
+
 Example kernel-doc data structure comment.
 
 /**
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
leds-add-a-dac124s085-spi-led-driver-fix.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver-select-serial_core.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
jbd-remove-excess-kernel-doc-notation.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch

