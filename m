From: akpm@linux-foundation.org
Subject: + fix-a-typo-in-documentation-sysctl-usertxt.patch added to -mm
 tree
Date: Mon, 05 Feb 2018 16:13:27 -0800
Message-ID: <5a78f327.rHrNSi/U7yNh4qVi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37736 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752150AbeBFAN3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Feb 2018 19:13:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: l4stpr0gr4m@gmail.com, akpm@linux-foundation.org, trivial@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/sysctl/user.txt: fix typo
has been added to the -mm tree.  Its filename is
     fix-a-typo-in-documentation-sysctl-usertxt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-a-typo-in-documentation-sysctl-usertxt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-a-typo-in-documentation-sysctl-usertxt.patch

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
Subject: Documentation/sysctl/user.txt: fix typo

Fix 'documetation' to 'documentation'

Link: http://lkml.kernel.org/r/CAKW4uUxRPZz59aWAX8ytaCB5=Qh6d_CvAnO7rYq-6NRAnQJbDA@mail.gmail.com
Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/user.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/user.txt~fix-a-typo-in-documentation-sysctl-usertxt Documentation/sysctl/user.txt
--- a/Documentation/sysctl/user.txt~fix-a-typo-in-documentation-sysctl-usertxt
+++ a/Documentation/sysctl/user.txt
@@ -3,7 +3,7 @@ Documentation for /proc/sys/user/*	kerne
 
 ==============================================================
 
-This file contains the documetation for the sysctl files in
+This file contains the documentation for the sysctl files in
 /proc/sys/user.
 
 The files in this directory can be used to override the default
_

Patches currently in -mm which might be from l4stpr0gr4m@gmail.com are

fix-a-typo-in-documentation-sysctl-usertxt.patch

