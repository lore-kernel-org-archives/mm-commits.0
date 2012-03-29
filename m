From: akpm@linux-foundation.org
Subject: + maintainers-add-entry-for-sparse-checker.patch added to -mm tree
Date: Thu, 29 Mar 2012 13:22:12 -0700
Message-ID: <20120329202212.C508BA033B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:48834 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab2C2UWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Mar 2012 16:22:15 -0400
Received: by faaa19 with SMTP id a19so25154faa.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Mar 2012 13:22:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sparse@chrisli.org


The patch titled
     Subject: MAINTAINERS: add entry for sparse checker
has been added to the -mm tree.  Its filename is
     maintainers-add-entry-for-sparse-checker.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Christopher Li <sparse@chrisli.org>
Subject: MAINTAINERS: add entry for sparse checker

Signed-off-by: Christopher Li <sparse@chrisli.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN MAINTAINERS~maintainers-add-entry-for-sparse-checker MAINTAINERS
--- a/MAINTAINERS~maintainers-add-entry-for-sparse-checker
+++ a/MAINTAINERS
@@ -6295,6 +6295,15 @@ F:	drivers/tty/serial/sunsu.c
 F:	drivers/tty/serial/sunzilog.c
 F:	drivers/tty/serial/sunzilog.h
 
+SPARSE CHECKER
+M:	"Christopher Li" <sparse@chrisli.org>
+L:	linux-sparse@vger.kernel.org
+W:	https://sparse.wiki.kernel.org/
+T:	git git://git.kernel.org/pub/scm/devel/sparse/sparse.git
+T:	git git://git.kernel.org/pub/scm/devel/sparse/chrisl/sparse.git
+S:	Maintained
+F:	include/linux/compiler.h
+
 SPEAR PLATFORM SUPPORT
 M:	Viresh Kumar <viresh.kumar@st.com>
 L:	spear-devel@list.st.com
_
Subject: Subject: MAINTAINERS: add entry for sparse checker

Patches currently in -mm which might be from sparse@chrisli.org are

maintainers-add-entry-for-sparse-checker.patch

