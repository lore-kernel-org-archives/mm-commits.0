From: akpm@linux-foundation.org
Subject: + sysctl-fix-token-ring-procname.patch added to -mm tree
Date: Tue, 30 Oct 2007 13:00:16 -0700
Message-ID: <200710302000.l9UK0G6n025499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35051 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752760AbXJ3UBq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 16:01:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, davem@davemloft.net, dex@dragonslave.de, ebiederm@xmission.com


The patch titled
     sysctl: fix token-ring procname
has been added to the -mm tree.  Its filename is
     sysctl-fix-token-ring-procname.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: fix token-ring procname
From: Randy Dunlap <randy.dunlap@oracle.com>

Correct the token-ring sysctl procname.

Eric said: "token-ring" is the historical name we have used in /proc/sys
despite it being abbreviated tr in the kernel.  So this fix is definitely
correct.

Reported by: Daniel Exner <dex@dragonslave.de>:
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sysctl_check.c~sysctl-fix-token-ring-procname kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl-fix-token-ring-procname
+++ a/kernel/sysctl_check.c
@@ -738,7 +738,7 @@ static struct trans_ctl_table trans_net_
 	{ NET_ROSE,		"rose",		trans_net_rose_table },
 	{ NET_IPV6,		"ipv6",		trans_net_ipv6_table },
 	{ NET_X25,		"x25",		trans_net_x25_table },
-	{ NET_TR,		"tr",		trans_net_tr_table },
+	{ NET_TR,		"token-ring",	trans_net_tr_table },
 	{ NET_DECNET,		"decnet",	trans_net_decnet_table },
 	/*  NET_ECONET not used */
 	{ NET_SCTP,		"sctp",		trans_net_sctp_table },
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
git-kbuild.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
voyager-use-struct-instead-of-param.patch
sysctl-fix-token-ring-procname.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
