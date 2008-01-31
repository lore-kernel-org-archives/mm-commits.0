From: akpm@linux-foundation.org
Subject: + email-clientstxt-sylpheed-is-ok-at-imap.patch added to -mm tree
Date: Thu, 31 Jan 2008 13:41:19 -0800
Message-ID: <200801312141.m0VLfJLF012701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37232 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755665AbYAaVlb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 16:41:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, pj@sgi.com


The patch titled
     email-clients.txt: sylpheed is OK at IMAP
has been added to the -mm tree.  Its filename is
     email-clientstxt-sylpheed-is-ok-at-imap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: email-clients.txt: sylpheed is OK at IMAP
From: Randy Dunlap <randy.dunlap@oracle.com>

This comment is not helpful (no reason given) and is incorrect.
Just stick to facts that are useful regarding working on Linux.

(akpm: I've used sylpheed+imap for years)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/email-clients.txt |    1 -
 1 file changed, 1 deletion(-)

diff -puN Documentation/email-clients.txt~email-clientstxt-sylpheed-is-ok-at-imap Documentation/email-clients.txt
--- a/Documentation/email-clients.txt~email-clientstxt-sylpheed-is-ok-at-imap
+++ a/Documentation/email-clients.txt
@@ -170,7 +170,6 @@ Sylpheed (GUI)
 
 - Works well for inlining text (or using attachments).
 - Allows use of an external editor.
-- Not good for IMAP.
 - Is slow on large folders.
 - Won't do TLS SMTP auth over a non-SSL connection.
 - Has a helpful ruler bar in the compose window.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-alsa.patch
docbook-fix-drivers-base-class-warning.patch
git-kbuild.patch
hamradio-fix-dmascc-section-mismatch.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
tpm-infineon-section-mismatch.patch
tdfxfb-fix-section-mismatch-warnings.patch
uvesafb-small-cleanups.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
kernel-doc-prevent-duplicate-description-output.patch
kernel-doc-warn-on-badly-formatted-short-description.patch
email-clientstxt-sylpheed-is-ok-at-imap.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
profile-likely-unlikely-macros.patch
