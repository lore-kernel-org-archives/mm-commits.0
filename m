From: akpm@linux-foundation.org
Subject: + documentation-email-clientstxt-update-gmail-information.patch added to -mm tree
Date: Wed, 24 Feb 2010 13:05:52 -0800
Message-ID: <201002242105.o1OL5qPH020324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757591Ab0BXVF4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 16:05:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, mbligh@mbligh.org, rdunlap@xenotime.net


The patch titled
     Documentation/email-clients.txt: update gmail information
has been added to the -mm tree.  Its filename is
     documentation-email-clientstxt-update-gmail-information.patch

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
-
-Gmail is not convenient for lkml patches, but CAN be made to work.
+Another problem is that Gmail will base64-encode any message that has a
+non-ASCII character. That includes things like European names.
 
                                 ###
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

linux-next.patch
documentation-email-clientstxt-update-gmail-information.patch
sysctl-extern-cleanup-c_a_d.patch
sysctl-extern-cleanup-signal.patch
sysctl-extern-cleanup-binfmts.patch
sysctl-extern-cleanup-pid.patch
sysctl-extern-cleanup-mm.patch
sysctl-extern-cleanup-compat.patch
sysctl-extern-cleanup-latencytop.patch
sysctl-extern-cleanup-file-nr.patch
sysctl-extern-cleanup-rcu.patch
sysctl-extern-cleanup-block-iopoll.patch
sysctl-extern-cleanup-module.patch
sysctl-extern-cleanup-sg.patch
sysctl-extern-cleanup-acct.patch
sysctl-extern-cleanup-rtmutex.patch
sysctl-extern-cleanup-lockdep.patch
sysctl-extern-cleanup-poll.patch
sysctl-extern-cleanup-inotify.patch

