From: akpm@linux-foundation.org
Subject: + documentation-email-clientstxt-warn-about-word-wrap-bug-in-kmail.patch added to -mm tree
Date: Tue, 04 Jan 2011 15:04:18 -0800
Message-ID: <201101042304.p04N4I2D029288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48250 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919Ab1ADXEj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jan 2011 18:04:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasse.collin@tukaani.org, randy.dunlap@oracle.com


The patch titled
     Documentation/email-clients.txt: warn about word wrap bug in KMail
has been added to the -mm tree.  Its filename is
     documentation-email-clientstxt-warn-about-word-wrap-bug-in-kmail.patch

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

documentation-email-clientstxt-warn-about-word-wrap-bug-in-kmail.patch
decompressors-add-missing-init-ie-__init.patch
decompressors-get-rid-of-set_error_fn-macro.patch
decompressors-include-linux-slabh-in-linux-decompress-mmh.patch
decompressors-remove-unused-function-from-lib-decompress_unlzmac.patch
decompressors-fix-header-validation-in-decompress_unlzmac.patch
decompressors-check-for-read-errors-in-decompress_unlzmac.patch
decompressors-check-for-write-errors-in-decompress_unlzmac.patch
decompressors-validate-match-distance-in-decompress_unlzmac.patch
decompressors-check-for-write-errors-in-decompress_unlzoc.patch
decompressors-check-input-size-in-decompress_unlzoc.patch
decompressors-fix-callback-to-callback-mode-in-decompress_unlzoc.patch
decompressors-add-xz-decompressor-module.patch
decompressors-add-boot-time-xz-support.patch
decompressors-add-boot-time-xz-support-update.patch
x86-support-xz-compressed-kernel.patch

