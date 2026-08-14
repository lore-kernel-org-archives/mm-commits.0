Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB831F1534
	for <mm-commits@vger.kernel.org>; Fri, 14 Aug 2026 01:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786669719; cv=none; b=LdKwP1tRNqreMKEXphLBBqZGyuVaQ4muCQiW1E/LXpVKn38iTJH9y71G9CsOnpnSmhce449IvXkHSFsb6O3UzqNevBl4UGM3QVZC3i6n0En5e444/VMhJj59Sd4mzHXwLuGYxsEcaDGbZfJICpsfMkXxFyH18zZnSnYfaehw+eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786669719; c=relaxed/simple;
	bh=jB0P0cV+iBPmhgrAOkPtClZOq7ErJS4fUB5SwzEfzKA=;
	h=Date:To:From:Subject:Message-Id; b=uczmvxH/876NhqSCoZVVQ8Oubod27WSNuWoRAQVi1ZU0uRTmMCHJJ1vUPT6D/orkLoBBEI7bpHn5cAAz6K6nBpPeAIgzzEamd+42ljlma7xXPxcLiWpUEqhiak93eHquBjUDP+fSCC43pm96FE6KFooToqrHyMx3BrQrd8o0qqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HmzgjfMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HmzgjfMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5821F00A3A;
	Fri, 14 Aug 2026 01:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786669717;
	bh=VNFSgPgSA5kRxUxsaObrz9jmnVfxYTVeammPdL1a2EU=;
	h=Date:To:From:Subject;
	b=HmzgjfMb0VoizIksWIMVIHEAxLUU5ZkXCSX4zjiSph1zRjPEyzBIpJT8rCgs1Jjvy
	 FH9yXv7P+CcLJv1by92bcAprAUSArYYbMKLGDhsJVRI7h9Yv8vwwYN32XXnnWvv82W
	 Mf96FWAIWY+/OGaebCvwf6YuWenEUA4UFAFzOQAA=
Date: Thu, 13 Aug 2026 18:08:37 -0700
To: mm-commits@vger.kernel.org,docular.xu@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entries-for-guodong-xu.patch removed from -mm tree
Message-Id: <20260814010837.8B5821F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entries for Guodong Xu
has been removed from the -mm tree.  Its filename was
     mailmap-add-entries-for-guodong-xu.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Guodong Xu <docular.xu@gmail.com>
Subject: mailmap: add entries for Guodong Xu
Date: Fri, 07 Aug 2026 18:12:34 -0400

Map my old Linaro and RISCstar email addresses to my current personal
address.  Neither former address receives mail anymore.

Link: https://lore.kernel.org/20260807-b4-mailmap-guodong-xu-v2-1-f7c71bc6bd9f@gmail.com
Signed-off-by: Guodong Xu <docular.xu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 ++
 1 file changed, 2 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-guodong-xu
+++ a/.mailmap
@@ -325,6 +325,8 @@ Gokul Sriram Palanisamy <quic_gokulsri@q
 Govindaraj Saminathan <quic_gsamin@quicinc.com> <gsamin@codeaurora.org>
 Guo Ren <guoren@kernel.org> <guoren@linux.alibaba.com>
 Guo Ren <guoren@kernel.org> <ren_guo@c-sky.com>
+Guodong Xu <docular.xu@gmail.com> <guodong.xu@linaro.org>
+Guodong Xu <docular.xu@gmail.com> <guodong@riscstar.com>
 Guru Das Srinagesh <linux@gurudas.dev>
 Guru Das Srinagesh <linux@gurudas.dev> <quic_gurus@quicinc.com>
 Guru Das Srinagesh <linux@gurudas.dev> <gurus@codeaurora.org>
_

Patches currently in -mm which might be from docular.xu@gmail.com are


