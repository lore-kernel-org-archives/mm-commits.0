From: akpm@linux-foundation.org
Subject: + fix-a-typo-in-documentation-sysctl-vmtxt.patch added to -mm
 tree
Date: Tue, 17 Oct 2017 14:55:54 -0700
Message-ID: <59e67c6a.2dZAWlFrCgf8VZ6u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51178 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966338AbdJQVzz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 17:55:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: l4stpr0gr4m@gmail.com, alan@redhat.com, trivial@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/sysctl/vm.txt: fix typo
has been added to the -mm tree.  Its filename is
     fix-a-typo-in-documentation-sysctl-vmtxt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-a-typo-in-documentation-sysctl-vmtxt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-a-typo-in-documentation-sysctl-vmtxt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -778,7 +778,7 @@ with no ill effects: errors and warnings
 swappiness
 
 This control is used to define how aggressive the kernel will swap
-memory pages.  Higher values will increase agressiveness, lower values
+memory pages.  Higher values will increase aggressiveness, lower values
 decrease the amount of swap.  A value of 0 instructs the kernel not to
 initiate swap until the amount of free and file-backed pages is less
 than the high water mark in a zone.
_

Patches currently in -mm which might be from l4stpr0gr4m@gmail.com are

fix-a-typo-in-documentation-sysctl-vmtxt.patch

