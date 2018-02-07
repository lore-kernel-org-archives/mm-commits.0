From: akpm@linux-foundation.org
Subject: [merged] fix-a-typo-in-documentation-sysctl-usertxt.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 12:00:59 -0800
Message-ID: <20180207200059.AEb3Nazoo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60834 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754002AbeBGUBA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 15:01:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, l4stpr0gr4m@gmail.com, mm-commits@vger.kernel.org, trivial@kernel.org


The patch titled
     Subject: Documentation/sysctl/user.txt: fix typo
has been removed from the -mm tree.  Its filename was
     fix-a-typo-in-documentation-sysctl-usertxt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


