From: akpm@linux-foundation.org
Subject: [merged] fix-a-typo-in-documentation-sysctl-vmtxt.patch
 removed from -mm tree
Date: Mon, 20 Nov 2017 13:26:08 -0800
Message-ID: <20171120212608.4iN4tSgbf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40810 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752923AbdKTV0J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:26:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@redhat.com, l4stpr0gr4m@gmail.com, mm-commits@vger.kernel.org, trivial@kernel.org


The patch titled
     Subject: Documentation/sysctl/vm.txt: fix typo
has been removed from the -mm tree.  Its filename was
     fix-a-typo-in-documentation-sysctl-vmtxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kangmin Park <l4stpr0gr4m@gmail.com>
Subject: Documentation/sysctl/vm.txt: fix typo

Link: http://lkml.kernel.org/r/CAKW4uUyCi=PnKf3epgFVz8z=1tMtHSOHNm+fdNxrNw3-THvRCA@mail.gmail.com
Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~fix-a-typo-in-documentation-sysctl-vmtxt Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~fix-a-typo-in-documentation-sysctl-vmtxt
+++ a/Documentation/sysctl/vm.txt
@@ -818,7 +818,7 @@ tooling to work, you can do:
 swappiness
 
 This control is used to define how aggressive the kernel will swap
-memory pages.  Higher values will increase agressiveness, lower values
+memory pages.  Higher values will increase aggressiveness, lower values
 decrease the amount of swap.  A value of 0 instructs the kernel not to
 initiate swap until the amount of free and file-backed pages is less
 than the high water mark in a zone.
_

Patches currently in -mm which might be from l4stpr0gr4m@gmail.com are


