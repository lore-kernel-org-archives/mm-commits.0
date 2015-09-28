From: akpm@linux-foundation.org
Subject: + mm-doc-fix-misleading-code-reference-of-overcommit_memory.patch added to -mm tree
Date: Mon, 28 Sep 2015 15:34:49 -0700
Message-ID: <5609c089.kRE1Pz45yc+J/bqz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbbI1Weu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Sep 2015 18:34:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chenchun.feed@gmail.com, mhocko@suse.com, ramichen@tencent.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/sysctl/vm.txt: fix misleading code reference of overcommit_memory
has been added to the -mm tree.  Its filename is
     mm-doc-fix-misleading-code-reference-of-overcommit_memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-doc-fix-misleading-code-reference-of-overcommit_memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-doc-fix-misleading-code-reference-of-overcommit_memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-doc-fix-misleading-code-reference-of-overcommit_memory.patch

