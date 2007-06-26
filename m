From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix.patch added to -mm tree
Date: Mon, 25 Jun 2007 20:46:31 -0700
Message-ID: <200706260346.l5Q3kVBT017641@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58046 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753046AbXFZDqr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 23:46:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, neilb@suse.de


The patch titled
     knfsd: nfsd4: vary maximum delegation limit based on RAM size (fix)
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: nfsd4: vary maximum delegation limit based on RAM size (fix)
From: "J. Bruce Fields" <bfields@fieldses.org>

I missed a compile warning here, apologies.

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/nfsd/nfs4state.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix
+++ a/fs/nfsd/nfs4state.c
@@ -3200,7 +3200,7 @@ get_nfs4_grace_period(void)
 }
 
 static void
-set_max_delegations()
+set_max_delegations(void)
 {
 	struct sysinfo sys;
 
_

Patches currently in -mm which might be from bfields@fieldses.org are

nfs-refactor-ip-address-sanity-checks-in-nfs-client.patch
knfsd-nfsd4-fix-nfsv4-filehandle-size-units-confusion.patch
knfsd-nfsd4-silence-a-compiler-warning-in-acl-code.patch
knfsd-nfsd4-fix-handling-of-acl-errrors.patch
knfsd-nfsd-remove-unused-header-interfaceh.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size-fix.patch
