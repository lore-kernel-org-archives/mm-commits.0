From: akpm@linux-foundation.org
Subject: - documentation-email-clientstxt-add-some-info-about-gmail.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:32:38 -0800
Message-ID: <200811102032.mAAKWcoT024036@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753231AbYKJUhw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:37:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thockin@google.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/email-clients.txt: add some info about gmail
has been removed from the -mm tree.  Its filename was
     documentation-email-clientstxt-add-some-info-about-gmail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/email-clients.txt: add some info about gmail
From: Tim Hockin <thockin@google.com>

Signed-off-by: Tim Hockin <thockin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/email-clients.txt |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -puN Documentation/email-clients.txt~documentation-email-clientstxt-add-some-info-about-gmail Documentation/email-clients.txt
--- a/Documentation/email-clients.txt~documentation-email-clientstxt-add-some-info-about-gmail
+++ a/Documentation/email-clients.txt
@@ -213,4 +213,29 @@ TkRat (GUI)
 
 Works.  Use "Insert file..." or external editor.
 
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+Gmail (Web GUI)
+
+If you just have to use Gmail to send patches, it CAN be made to work.  It
+requires a bit of external help, though.
+
+The first problem is that Gmail converts tabs to spaces.  This will
+totally break your patches.  To prevent this, you have to use a different
+editor.  There is a firefox extension called "ViewSourceWith"
+(https://addons.mozilla.org/en-US/firefox/addon/394) which allows you to
+edit any text box in the editor of your choice.  Configure it to launch
+your favorite editor.  When you want to send a patch, use this technique.
+Once you have crafted your messsage + patch, save and exit the editor,
+which should reload the Gmail edit box.  GMAIL WILL PRESERVE THE TABS.
+Hoorah.  Apparently you can cut-n-paste literal tabs, but Gmail will
+convert those to spaces upon sending!
+
+The second problem is that Gmail converts tabs to spaces on replies.  If
+you reply to a patch, don't expect to be able to apply it as a patch.
+
+The last problem is that Gmail will base64-encode any message that has a
+non-ASCII character.  That includes things like European names.  Be aware.
+
+Gmail is not convenient for lkml patches, but CAN be made to work.
+
                                 ###
_

Patches currently in -mm which might be from thockin@google.com are


