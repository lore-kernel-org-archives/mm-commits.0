From: akpm@linux-foundation.org
Subject: - local_t-update-documentation.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:59:29 -0700
Message-ID: <200710180659.l9I6xTGr030988@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45910 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755825AbXJRG7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 02:59:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, grundler@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     local_t: update documentation
has been removed from the -mm tree.  Its filename was
     local_t-update-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: local_t: update documentation
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/local_ops.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/local_ops.txt~local_t-update-documentation Documentation/local_ops.txt
--- a/Documentation/local_ops.txt~local_t-update-documentation
+++ a/Documentation/local_ops.txt
@@ -27,7 +27,7 @@ CPU which owns the data. Therefore, care
 CPU writes to the local_t data. This is done by using per cpu data and making
 sure that we modify it from within a preemption safe context. It is however
 permitted to read local_t data from any CPU : it will then appear to be written
-out of order wrt other memory writes on the owner CPU.
+out of order wrt other memory writes by the owner CPU.
 
 
 * Implementation for a given architecture
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
change-struct-marker-users.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
linux-kernel-markers.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-coding-style-fixes.patch
linux-kernel-markers-alignment-fix.patch
add-samples-subdir.patch
linux-kernel-markers-samples.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
linux-kernel-markers-samples-coding-style-fix.patch
linux-kernel-markers-samples-remove-asm.patch
linux-kernel-markers-documentation.patch
