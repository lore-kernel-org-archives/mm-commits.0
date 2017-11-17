From: akpm@linux-foundation.org
Subject: [patch 71/94] Documentation/sysctl/vm.txt: fix typo
Date: Fri, 17 Nov 2017 15:30:23 -0800
Message-ID: <20171117233023.bPzxF-FlQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55974 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966147AbdKQXaZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:30:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@redhat.com, l4stpr0gr4m@gmail.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, trivial@kernel.org

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
