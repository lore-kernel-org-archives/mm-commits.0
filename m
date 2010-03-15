From: akpm@linux-foundation.org
Subject: [merged] documentation-email-clientstxt-update-gmail-information.patch removed from -mm tree
Date: Sun, 14 Mar 2010 23:58:04 -0400
Message-ID: <201003150658.o2F6wboh016467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935214Ab0COG6l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 02:58:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, mbligh@mbligh.org, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Documentation/email-clients.txt: update gmail information
has been removed from the -mm tree.  Its filename was
     documentation-email-clientstxt-update-gmail-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/email-clients.txt: update gmail information
From: Dave Young <hidave.darkstar@gmail.com>

Gmail web gui does not work for sending patches now even with firefox
"view source with" extension.  It will use windows style line breaks to
wrap lines automatically when sening email.

Rewrite the gmail web gui part of email client documentation.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Martin Bligh <mbligh@mbligh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/email-clients.txt |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff -puN Documentation/email-clients.txt~documentation-email-clientstxt-update-gmail-information Documentation/email-clients.txt
--- a/Documentation/email-clients.txt~documentation-email-clientstxt-update-gmail-information
+++ a/Documentation/email-clients.txt
@@ -216,26 +216,14 @@ Works.  Use "Insert file..." or external
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 Gmail (Web GUI)
 
-If you just have to use Gmail to send patches, it CAN be made to work.  It
-requires a bit of external help, though.
+Does not work for sending patches.
 
-The first problem is that Gmail converts tabs to spaces.  This will
-totally break your patches.  To prevent this, you have to use a different
-editor.  There is a firefox extension called "ViewSourceWith"
-(https://addons.mozilla.org/en-US/firefox/addon/394) which allows you to
-edit any text box in the editor of your choice.  Configure it to launch
-your favorite editor.  When you want to send a patch, use this technique.
-Once you have crafted your messsage + patch, save and exit the editor,
-which should reload the Gmail edit box.  GMAIL WILL PRESERVE THE TABS.
-Hoorah.  Apparently you can cut-n-paste literal tabs, but Gmail will
-convert those to spaces upon sending!
+Gmail web client converts tabs to spaces automatically.
 
-The second problem is that Gmail converts tabs to spaces on replies.  If
-you reply to a patch, don't expect to be able to apply it as a patch.
+At the same time it wraps lines every 78 chars with CRLF style line breaks
+although tab2space problem can be solved with external editor.
 
-The last problem is that Gmail will base64-encode any message that has a
-non-ASCII character.  That includes things like European names.  Be aware.
