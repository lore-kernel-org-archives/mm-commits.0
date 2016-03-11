From: akpm@linux-foundation.org
Subject: +
 maintainers-update-the-email-address-of-james-ej-bottomley.patch added to
 -mm tree
Date: Fri, 11 Mar 2016 12:03:43 -0800
Message-ID: <56e3249f.QhCue8idrf4Mcipb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbcCKUDo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Mar 2016 15:03:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bigeasy@linutronix.de, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update the email address of James E.J. Bottomley
has been added to the -mm tree.  Its filename is
     maintainers-update-the-email-address-of-james-ej-bottomley.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/maintainers-update-the-email-address-of-james-ej-bottomley.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/maintainers-update-the-email-address-of-james-ej-bottomley.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Return-Path: <bigeasy@linutronix.de>
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on z
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.5 tests=BAYES_00 autolearn=ham
	version=3.3.1
Received: from localhost (localhost [127.0.0.1])
	by localhost.localdomain (8.14.3/8.14.3) with ESMTP id u2BINSal009286
	for <akpm@localhost>; Fri, 11 Mar 2016 10:23:28 -0800
X-Original-To: akpm@mail.linuxfoundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by localhost with IMAP (fetchmail-6.3.11)
	for <akpm@localhost> (single-drop); Fri, 11 Mar 2016 10:23:28 -0800 (PST)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTPS id 69E71C57
	for <akpm@mail.linuxfoundation.org>; Fri, 11 Mar 2016 18:22:40 +0000 (UTC)
X-Greylist: whitelisted by SQLgrey-1.7.6
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id 968931A0
	for <akpm@mail.linuxfoundation.org>; Fri, 11 Mar 2016 18:22:39 +0000 (UTC)
Received: by mail-wm0-f47.google.com with SMTP id n186so29941630wmn.1
        for <akpm@mail.linuxfoundation.org>; Fri, 11 Mar 2016 10:22:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20130820;
        h=x-original-authentication-results:x-gm-message-state:from:to:cc
         :subject:date:message-id:delivered-to;
        bh=FcdnFlzJvxRodxKo+GDveCnvCz1v5x4MLZ+3MfQ5M58=;
        b=DP+yZxsMYlIV29uQaOAF0xQ7N2wbqtn64/UMrkqLzkugwCLRWhiQGZVZ6o89BSlXNs
         tkPmNYlWVsgptiGwhdFW2Km6Wiqp+aefNPlhQEEI922Nj/xqvvj9Bb/Gc9mNqjhW8kxn
         JXd3tP/EH3jfXpQHqjzupfQUCx3O8fIAyoJ3RypWqie4k9+2ouOBbiT62fjuVPI1nDzy
         +xChugXJnC6iZ57idsu07Mc5QVQpFnRc7B9Xk9GA2LTz8xfFX7vKOExFxnj0TZR/gzs3
         jo2FUUMowUQzZTH7VN635tXgUh1PiP/IGVbK41uJKkgPLMSv+DLxu+NWnLBW6MYRQzwx
         FmSw==
X-Original-Authentication-Results: mx.google.com;       spf=pass (google.com: best guess record for domain of bigeasy@linutronix.de designates 2001:470:1f0b:db:abcd:42:0:1 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
X-Gm-Message-State: AD7BkJKAsMCIqkymfcEoQcUuhryUJBykWuxEUC5/YXyjdzNFTLpFEVBZpjINyP/CetVQhxOxAaD5GbPpRF+wtoTXMwI30078R8bIQwXeN/Af1Ua2jchoaOl04Jw7iucZ7TWrlRgBqknbKQ3rucP/9b/AvJvMFyvJMFQzbI6B7HSPP0qse4BNHjTwjvKnXw7fy3VSAg==
X-Received: by 10.28.182.194 with SMTP id g185mr4484281wmf.41.1457720558249;
        Fri, 11 Mar 2016 10:22:38 -0800 (PST)
X-Received: by 10.28.182.194 with SMTP id g185mr4484234wmf.41.1457720557771;
        Fri, 11 Mar 2016 10:22:37 -0800 (PST)
Received: from Galois.linutronix.de (linutronix.de. [2001:470:1f0b:db:abcd:42:0:1])
        by mx.google.com with ESMTPS id k184si4098209wma.49.2016.03.11.10.22.37
        for <akpm@linux-foundation.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Fri, 11 Mar 2016 10:22:37 -0800 (PST)
Received-SPF: pass (google.com: best guess record for domain of bigeasy@linutronix.de designates 2001:470:1f0b:db:abcd:42:0:1 as permitted sender) client-ip=2001:470:1f0b:db:abcd:42:0:1;
Authentication-Results: mx.google.com;
       spf=pass (google.com: best guess record for domain of bigeasy@linutronix.de designates 2001:470:1f0b:db:abcd:42:0:1 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
Received: from localhost ([127.0.0.1] helo=bazinga.breakpoint.cc)
	by Galois.linutronix.de with esmtp (Exim 4.80)
	(envelope-from <bigeasy@linutronix.de>)
	id 1aeRhr-0000Mk-7s; Fri, 11 Mar 2016 19:22:35 +0100
To: "James E . J . Bottomley " <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: MAINTAINERS: Update the email address of James E.J. Bottomley
Date: Fri, 11 Mar 2016 19:22:19 +0100
Message-Id: <1457720539-25849-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.7.0
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Delivered-To: akpm@linux-foundation.org

after sending a few patches to the odin.com email address I noticed that
it is no longer valid.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2a37ee56f4c5..4307201a866c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9668,7 +9668,7 @@ F:	drivers/scsi/sg.c
 F:	include/scsi/sg.h
 
 SCSI SUBSYSTEM
-M:	"James E.J. Bottomley" <JBottomley@odin.com>
+M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
 M:	"Martin K. Petersen" <martin.petersen@oracle.com>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
-- 
2.7.0

Patches currently in -mm which might be from bigeasy@linutronix.de are

maintainers-update-the-email-address-of-james-ej-bottomley.patch

