From: akpm@linux-foundation.org
Subject: [folded-merged] timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:07:32 -0800
Message-ID: <20130221230732.B44005A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:50262 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab3BUXHe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:07:34 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so9634ggi.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:07:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, nzimmer@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-fix
has been removed from the -mm tree.  Its filename was
     timer_list-convert-timer-list-to-be-a-proper-seq_file-fix.patch

This patch was dropped because it was folded into timer_list-convert-timer-list-to-be-a-proper-seq_file.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: timer_list-convert-timer-list-to-be-a-proper-seq_file-fix

whitespace fixlet

Cc: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/timer_list.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-fix kernel/time/timer_list.c
--- a/kernel/time/timer_list.c~timer_list-convert-timer-list-to-be-a-proper-seq_file-fix
+++ a/kernel/time/timer_list.c
@@ -274,7 +274,6 @@ static int timer_list_show(struct seq_fi
 	return 0;
 }
 
