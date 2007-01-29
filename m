From: akpm@osdl.org
Subject: - netfilter-is-subscribers-only.patch removed from -mm tree
Date: Mon, 29 Jan 2007 13:17:19 -0800
Message-ID: <200701292117.l0TLHJUx031171@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57229 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbXA2VRg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jan 2007 16:17:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, davem@davemloft.net, kaber@trash.net, mm-commits@vger.kernel.org


The patch titled
     netfilter@ is subscribers-only
has been removed from the -mm tree.  Its filename was
     netfilter-is-subscribers-only.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: netfilter@ is subscribers-only
From: Randy Dunlap <randy.dunlap@oracle.com>


netfilter mailing list is subscribers-only.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~netfilter-is-subscribers-only MAINTAINERS
--- a/MAINTAINERS~netfilter-is-subscribers-only
+++ a/MAINTAINERS
@@ -2336,7 +2336,7 @@ P:	Jozsef Kadlecsik
 P:	Patrick McHardy
 M:	kaber@trash.net
 L:	netfilter-devel@lists.netfilter.org
-L:	netfilter@lists.netfilter.org
+L:	netfilter@lists.netfilter.org (subscribers-only)
 L:	coreteam@netfilter.org
 W:	http://www.netfilter.org/
 W:	http://www.iptables.org/
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-alsa.patch
git-gfs2-nmw.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
git-net.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-misc.patch
math-emu-setcc-avoid-gcc-extension.patch
typeof-__page_to_pfn-with-sparsemem=y.patch
docbook-html-correction-of-recursive-a-tags-in-html-output.patch
kernel-doc-allow-a-little-whitespace.patch
sysrq-showblockedtasks-is-sysrq-w.patch
sysrq-alphabetize-command-keys-doc.patch
kernel-doc-allow-more-whitespace.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
docbook-add-edd-firmware-interfaces.patch
kernel-doc-fix-some-odd-spacing-issues.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
