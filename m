From: akpm@linux-foundation.org
Subject: [merged] email-clients-add-better-thunderbird-information.patch removed from -mm tree
Date: Tue, 16 Aug 2011 11:51:48 -0700
Message-ID: <201108161848.p7GImt8E015417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156Ab1HPSt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 14:49:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmcquad@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Email-clients: add better Thunderbird information
has been removed from the -mm tree.  Its filename was
     email-clients-add-better-thunderbird-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Email-clients: add better Thunderbird information
From: Paul Mcquade <paulmcquad@gmail.com>

Add Thunderbird Registry instructions to:
Enable UTF8 & Preformat mode
Disable HTML mode

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/email-clients.txt |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN Documentation/email-clients.txt~email-clients-add-better-thunderbird-information Documentation/email-clients.txt
--- a/Documentation/email-clients.txt~email-clients-add-better-thunderbird-information
+++ a/Documentation/email-clients.txt
@@ -199,18 +199,16 @@ to coerce it into behaving.
 
 To beat some sense out of the internal editor, do this:
 
-- Under account settings, composition and addressing, uncheck "Compose
-  messages in HTML format".
