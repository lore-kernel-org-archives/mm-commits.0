Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC2730F7FB
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338641; cv=none; b=dcnL1xWOPklG+tlH1+BPC8xVjtMXlkot7iiDxohnH6TZOWY9a/s8Y52tMLLkK1EcIY7CCVtAgRJqsHNZCEq5q7MnKHHE+1u0YYBqVcxCiu1eydcE1U/netEvWdoblVajsuEE7bPwzcZ2eAq4dnH3FHzhKpD9Vd4bE4GiaXjmA2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338641; c=relaxed/simple;
	bh=CjqorxIjg2wPXxDHr0ALx4pvH4Np2L7CW3FtMhdifQI=;
	h=Date:To:From:Subject:Message-Id; b=H57wyWguMPTEr+408lEmFeygm3goTvuZHOI0nCRh0dU/D0zNFLS6Xy9Vepz6jeeMR2kgCZOC/d08MY6Tl3DGvI6M9isOPKVtHyT8+nAqyEOAmfiPkvK4fBEJ22LZ90alp28nz99v61CnFp7tx19xlEh2404lFfSkoDkmTF204Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DNusRi0e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DNusRi0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960B91F0089B;
	Wed,  7 Oct 2026 02:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338638;
	bh=VUuRRs7NMcbM4m+wdG8YxJyyE4e58xncnhUu3uBeQg0=;
	h=Date:To:From:Subject;
	b=DNusRi0e2zGeVD6Lr/rKNmhEhQFeljX7eisAstv2b0vdkwR4SymcS6IzAcF0M6NzZ
	 pELP8oJkJgRspPQU9kXSRNOzNoQYKxcXrSbrwVTRWZQqEVgfpcEe+F9HLRxwH8lCAc
	 LVM2KoqhM0RXBHrUp1rJ81Y14NEA5kEsnL6syJ80=
Date: Tue, 06 Oct 2026 19:03:58 -0700
To: mm-commits@vger.kernel.org,brads@mainlining.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-update-email-address-for-bradley-morgan.patch removed from -mm tree
Message-Id: <20261007020358.960B91F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: update email address for Bradley Morgan
has been removed from the -mm tree.  Its filename was
     mailmap-update-email-address-for-bradley-morgan.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bradley Morgan <brads@mainlining.org>
Subject: mailmap: update email address for Bradley Morgan
Date: Tue, 25 Aug 2026 15:11:57 +0000

I switched to brads@mainlining.org for kernel work, so map the old
include@grrlz.net address over to keep shortlog and blame from splitting
commits between the two.

Link: https://lore.kernel.org/20260825151157.4533-1-brads@mainlining.org
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-email-address-for-bradley-morgan
+++ a/.mailmap
@@ -171,6 +171,7 @@ Boris Brezillon <bbrezillon@kernel.org>
 Boris Brezillon <bbrezillon@kernel.org> <b.brezillon@overkiz.com>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@bootlin.com>
 Boris Brezillon <bbrezillon@kernel.org> <boris.brezillon@free-electrons.com>
+Bradley Morgan <brads@mainlining.org> <include@grrlz.net>
 Brendan Higgins <brendan.higgins@linux.dev> <brendanhiggins@google.com>
 Brendan Jackman <brendan.jackman@linux.dev> <jackmanb@google.com>
 Brian Avery <b.avery@hp.com>
_

Patches currently in -mm which might be from brads@mainlining.org are

watchdog-perf-one-digit-too-short-in-the-raw-event-config-copy.patch

