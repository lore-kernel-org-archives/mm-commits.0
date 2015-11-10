From: akpm@linux-foundation.org
Subject: [merged]
 mm-doc-fix-misleading-code-reference-of-overcommit_memory.patch removed
 from -mm tree
Date: Tue, 10 Nov 2015 12:33:10 -0800
Message-ID: <56425486.pOQSXIe0Aa3mvhH+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbbKJUdK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenchun.feed@gmail.com, mhocko@suse.com, ramichen@tencent.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/sysctl/vm.txt: fix misleading code reference of overcommit_memory
has been removed from the -mm tree.  Its filename was
     mm-doc-fix-misleading-code-reference-of-overcommit_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chun Chen <chenchun.feed@gmail.com>
Subject: Documentation/sysctl/vm.txt: fix misleading code reference of overcommit_memory

The origin document references to cap_vm_enough_memory is because
cap_vm_enough_memory invoked __vm_enough_memory before and it no longer
does now.

Signed-off-by: Chun Chen <ramichen@tencent.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~mm-doc-fix-misleading-code-reference-of-overcommit_memory Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-doc-fix-misleading-code-reference-of-overcommit_memory
+++ a/Documentation/sysctl/vm.txt
@@ -639,7 +639,7 @@ and don't use much of it.
 The default value is 0.
 
 See Documentation/vm/overcommit-accounting and
-security/commoncap.c::cap_vm_enough_memory() for more information.
+mm/mmap.c::__vm_enough_memory() for more information.
 
 ==============================================================
 
_

Patches currently in -mm which might be from chenchun.feed@gmail.com are


