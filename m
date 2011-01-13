From: akpm@linux-foundation.org
Subject: [merged] documentation-email-clientstxt-warn-about-word-wrap-bug-in-kmail.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:08:21 -0800
Message-ID: <201101132011.p0DKB2mv030121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933693Ab1AMULs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:11:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasse.collin@tukaani.org, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/email-clients.txt: warn about word wrap bug in KMail
has been removed from the -mm tree.  Its filename was
     documentation-email-clientstxt-warn-about-word-wrap-bug-in-kmail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/email-clients.txt: warn about word wrap bug in KMail
From: Lasse Collin <lasse.collin@tukaani.org>

Signed-off-by: Lasse Collin <lasse.collin@tukaani.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/email-clients.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/email-clients.txt~documentation-email-clientstxt-warn-about-word-wrap-bug-in-kmail Documentation/email-clients.txt
--- a/Documentation/email-clients.txt~documentation-email-clientstxt-warn-about-word-wrap-bug-in-kmail
+++ a/Documentation/email-clients.txt
@@ -104,6 +104,13 @@ Then from the "Message" menu item, selec
 As an added bonus you can customise the message creation toolbar menu
 and put the "insert file" icon there.
 
+Make the the composer window wide enough so that no lines wrap. As of
+KMail 1.13.5 (KDE 4.5.4), KMail will apply word wrapping when sending
+the email if the lines wrap in the composer window. Having word wrapping
+disabled in the Options menu isn't enough. Thus, if your patch has very
+long lines, you must make the composer window very wide before sending
+the email. See: https://bugs.kde.org/show_bug.cgi?id=174034
+
 You can safely GPG sign attachments, but inlined text is preferred for
 patches so do not GPG sign them.  Signing patches that have been inserted
 as inlined text will make them tricky to extract from their 7-bit encoding.
_

Patches currently in -mm which might be from lasse.collin@tukaani.org are

origin.patch

