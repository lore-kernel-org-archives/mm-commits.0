From: akpm@linux-foundation.org
Subject: - add-reset_devices-to-the-recommended-parameters.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:36 -0700
Message-ID: <200710180704.l9I74avV031566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49414 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761302AbXJRHlZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:41:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, ebiederm@xmission.com, hbabu@us.ibm.com, rdunlap@xenotime.net, vgoyal@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Add reset_devices to the recommended parameters
has been removed from the -mm tree.  Its filename was
     add-reset_devices-to-the-recommended-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add reset_devices to the recommended parameters
From: Bernhard Walle <bwalle@suse.de>

This patch adds the "reset_devices" option (that's used only by one device
driver for now) to the recommended list of command line parameters for kdump.

Meaning (Documentation/kernel-parameters.txt):
    reset_devices   [KNL] Force drivers to reset the underlying device
                    during initialization.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/kdump/kdump.txt~add-reset_devices-to-the-recommended-parameters Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~add-reset_devices-to-the-recommended-parameters
+++ a/Documentation/kdump/kdump.txt
@@ -292,10 +292,10 @@ Following are the arch specific command 
 loading dump-capture kernel.
 
 For i386, x86_64 and ia64:
-	"1 irqpoll maxcpus=1"
+	"1 irqpoll maxcpus=1 reset_devices"
 
 For ppc64:
-	"1 maxcpus=1 noirqdistrib"
+	"1 maxcpus=1 noirqdistrib reset_devices"
 
 
 Notes on loading the dump-capture kernel:
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
extended-crashkernel-command-line.patch
extended-crashkernel-command-line-update.patch
extended-crashkernel-command-line-comment-fix.patch
extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-i386-update.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-x86_64-update.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
use-extended-crashkernel-command-line-on-ia64-update.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-ppc64-update.patch
use-extended-crashkernel-command-line-on-sh.patch
use-extended-crashkernel-command-line-on-sh-update.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
