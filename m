From: akpm@linux-foundation.org
Subject: + mm-migratec-remove-the-unused-macro-lru_to_page.patch added to -mm tree
Date: Thu, 29 Dec 2011 14:34:33 -0800
Message-ID: <20111229223435.374EE200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51980 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab1L2Wei (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Dec 2011 17:34:38 -0500
Received: by eaak10 with SMTP id k10so201055eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 29 Dec 2011 14:34:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shhuiw@gmail.com


The patch titled
     Subject: mm/migrate.c: remove the unused macro lru_to_page
has been added to the -mm tree.  Its filename is
     mm-migratec-remove-the-unused-macro-lru_to_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wang Sheng-Hui <shhuiw@gmail.com>
Subject: mm/migrate.c: remove the unused macro lru_to_page

lru_to_page is not used in mm/migrate.c.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/migrate.c~mm-migratec-remove-the-unused-macro-lru_to_page mm/migrate.c
--- a/mm/migrate.c~mm-migratec-remove-the-unused-macro-lru_to_page
+++ a/mm/migrate.c
@@ -39,8 +39,6 @@
 
 #include "internal.h"
 
-#define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
