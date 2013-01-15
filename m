From: akpm@linux-foundation.org
Subject: + tools-vm-add-gitignore-to-ignore-built-binaries.patch added to -mm tree
Date: Tue, 15 Jan 2013 13:53:57 -0800
Message-ID: <20130115215358.08A2020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:60021 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3AOVyB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jan 2013 16:54:01 -0500
Received: by mail-la0-f74.google.com with SMTP id ej20so43091lab.3
        for <mm-commits@vger.kernel.org>; Tue, 15 Jan 2013 13:54:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: iamjoonsoo.kim@lge.com


The patch titled
     Subject: tools/vm: add .gitignore to ignore built binaries
has been added to the -mm tree.  Its filename is
     tools-vm-add-gitignore-to-ignore-built-binaries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: tools/vm: add .gitignore to ignore built binaries

There is no .gitignore in tools/vm, so 'git status' always show built
binaries.  To ignore this, add .gitignore.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/.gitignore |    2 ++
 1 file changed, 2 insertions(+)

diff -puN /dev/null tools/vm/.gitignore
--- /dev/null
+++ a/tools/vm/.gitignore
@@ -0,0 +1,2 @@
+slabinfo
+page-types
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

tools-vm-add-gitignore-to-ignore-built-binaries.patch

