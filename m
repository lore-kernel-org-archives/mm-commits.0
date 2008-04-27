From: akpm@linux-foundation.org
Subject: + maintainers-clarify-status-of-mn10300-mailing-list-as-moderated.patch added to -mm tree
Date: Sun, 27 Apr 2008 12:05:02 -0700
Message-ID: <200804271905.m3RJ52d7020329@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42321 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762306AbYD0TFx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 15:05:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, dhowells@redhat.com


The patch titled
     MAINTAINERS: clarify status of MN10300 mailing list as moderated
has been added to the -mm tree.  Its filename is
     maintainers-clarify-status-of-mn10300-mailing-list-as-moderated.patch

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
Subject: MAINTAINERS: clarify status of MN10300 mailing list as moderated
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-clarify-status-of-mn10300-mailing-list-as-moderated MAINTAINERS
--- a/MAINTAINERS~maintainers-clarify-status-of-mn10300-mailing-list-as-moderated
+++ a/MAINTAINERS
@@ -2701,7 +2701,7 @@ P:	David Howells
 M:	dhowells@redhat.com
 P:	Koichi Yasutake
 M:	yasutake.koichi@jp.panasonic.com
-L:	linux-am33-list@redhat.com
+L:	linux-am33-list@redhat.com (moderated for non-subscribers)
 W:	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/
 S:	Maintained
 
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
git-mtd.patch
git-nfsd.patch
xtensa-warn-about-including-asm-rwsemh-directly.patch
xtensa-use-newer-__spin_lock_unlocked-macro.patch
kernel-explicitly-include-required-header-files-under-kernel.patch
remove-superfluous-include-of-stringh-from-percpuh.patch
kbuild-remove-duplicate-conflicting-entry-for-oomh.patch
kbuild-move-files-that-dont-check-__kernel__.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
maintainers-clarify-status-of-mn10300-mailing-list-as-moderated.patch
mfd-use-shorter-set_current_state.patch
isdn-fix-obvious-cut-and-paste-error-in-st5481_usbc.patch
keys-explicitly-include-required-slabh-header-file.patch
nbd-delete-superfluous-test-for-__gnuc__.patch
generalize-asm-generic-ioctlh-to-allow-overriding-values.patch
edac-use-the-shorter-list_head-for-brevity.patch
afs-use-the-shorter-list_head-for-brevity.patch
sysv-fs-remove-superfluous-check-for-__gnuc__-compiler.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch
remove-__kernel__-tests-of-unexported-headers-under-asm-generic.patch
drop-the-exporting-of-empty-linux-byteorder-generich.patch

