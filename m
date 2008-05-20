From: akpm@linux-foundation.org
Subject: - xprtrdma-fix-err_ptre-typo.patch removed from -mm tree
Date: Tue, 20 May 2008 14:14:27 -0700
Message-ID: <200805202114.m4KLERwt011466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763341AbYETVYD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 May 2008 17:24:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, bfields@fieldses.org, davem@davemloft.net, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     xprtrdma: fix ERR_PTR(E typo
has been removed from the -mm tree.  Its filename was
     xprtrdma-fix-err_ptre-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xprtrdma: fix ERR_PTR(E typo
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/xprtrdma/svc_rdma_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/sunrpc/xprtrdma/svc_rdma_transport.c~xprtrdma-fix-err_ptre-typo net/sunrpc/xprtrdma/svc_rdma_transport.c
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c~xprtrdma-fix-err_ptre-typo
+++ a/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -661,7 +661,7 @@ static struct svc_xprt *svc_rdma_create(
 
 	cma_xprt = rdma_create_xprt(serv, 1);
 	if (!cma_xprt)
-		return ERR_PTR(ENOMEM);
+		return ERR_PTR(-ENOMEM);
 	xprt = &cma_xprt->sc_xprt;
 
 	listen_id = rdma_create_id(rdma_listen_handler, cma_xprt, RDMA_PS_TCP);
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
cifs-switch-to-seq_files.patch
atl1-fix-4g-memory-corruption-bug.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
move-proc_kmsg_operations-to-fs-proc-internalh.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

