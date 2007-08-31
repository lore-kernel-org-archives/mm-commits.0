From: akpm@linux-foundation.org
Subject: + local_t-update-documentation.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:50:46 -0700
Message-ID: <200708311850.l7VIok76021631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43662 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965951AbXHaSvC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:51:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, grundler@parisc-linux.org


The patch titled
     local_t: update documentation
has been added to the -mm tree.  Its filename is
     local_t-update-documentation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: local_t: update documentation
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/local_ops.txt |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

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

powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
git-mips.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
local_t-update-documentation.patch
