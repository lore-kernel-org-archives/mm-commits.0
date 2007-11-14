From: akpm@linux-foundation.org
Subject: - sysctl-fix-token-ring-procname.patch removed from -mm tree
Date: Wed, 14 Nov 2007 09:41:47 -0800
Message-ID: <200711141741.lAEHfl2Y017263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36724 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756984AbXKNRpw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 12:45:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, davem@davemloft.net, dex@dragonslave.de, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: fix token-ring procname
has been removed from the -mm tree.  Its filename was
     sysctl-fix-token-ring-procname.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: fix token-ring procname
From: Randy Dunlap <randy.dunlap@oracle.com>

Correct the token-ring sysctl procname.

Eric said: "token-ring" is the historical name we have used in /proc/sys
despite it being abbreviated tr in the kernel.  So this fix is definitely
correct.

Reported by: Daniel Exner <dex@dragonslave.de>:
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
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
chipsfb-uses-depends-on-pci.patch
git-dvb.patch
git-kbuild.patch
nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix-fix.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
gbefb-fix-section-mismatch-warnings.patch
vmstat-fix-section-mismatch-warning.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
