From: akpm@linux-foundation.org
Subject: + email-clients-add-better-thunderbird-information.patch added to -mm tree
Date: Tue, 16 Aug 2011 09:40:02 -0700
Message-ID: <201108161637.p7GGbAiF002951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48478 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295Ab1HPQhq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Aug 2011 12:37:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paulmcquad@gmail.com


The patch titled
     Email-clients: add better Thunderbird information
has been added to the -mm tree.  Its filename is
     email-clients-add-better-thunderbird-information.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
