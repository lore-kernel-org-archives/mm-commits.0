Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6615C3093C6
	for <mm-commits@vger.kernel.org>; Tue, 24 Feb 2026 19:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771960452; cv=none; b=g2zVm1npu3kzf15pNCyh1i71wlsF44mpwfxzW3uFj8F9GJ/A2qTFubbmeB+8f6iqPExE0tmL+ITwFTMtDCY7rKWQuH4FhnwyMPfkTaIBozmz8D8ClMTkchOL8qRUwq/I9IMY0TuT6VQeciRo4LuOeo9kr+k1hoKL6lu4cYUspys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771960452; c=relaxed/simple;
	bh=EWKcjyqg8AL+uh3yh/7rDNLPJz+ZS9H3ePvCNyPyZ8k=;
	h=Date:To:From:Subject:Message-Id; b=P3I5X4WijDsnSE7w3ErXi3tUUnvkapkxn/5vwmnmY2O69Hp8+V+u0W0TQDrOO7iAiaki9+SZi1gOCs3C6BcIUhS3n0EqHdFToPDrBQ6jnwDZ3Zgm8pUN7Fj1gGy1RNPAmsfRibyQdXql94EJGP591/gidPCrK/6l7eKDmmWVv4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IeCA/R+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IeCA/R+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 742EEC19422;
	Tue, 24 Feb 2026 19:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771960451;
	bh=EWKcjyqg8AL+uh3yh/7rDNLPJz+ZS9H3ePvCNyPyZ8k=;
	h=Date:To:From:Subject:From;
	b=IeCA/R+uEsF1QVJuAmgU5ztqKg39uRt5w4AAoovC/S2Ll016g2A6gAggkwhKtWXRW
	 h9Poe/NjBB81xFhl1NgLvzObTGJcGefNUrPRLGFkMML7i62v/gKggnSKNFyPUWmicp
	 MvdNQk8sDi4QTvBvx4OzzRzEMRhxfakTJU7xePZU=
Date: Tue, 24 Feb 2026 11:14:10 -0800
To: mm-commits@vger.kernel.org,daniele.alessandrelli@gmail.com,daniele.alessandrelli@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-daniele-alessandrelli.patch removed from -mm tree
Message-Id: <20260224191411.742EEC19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entry for Daniele Alessandrelli
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-daniele-alessandrelli.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Subject: mailmap: add entry for Daniele Alessandrelli
Date: Mon, 23 Feb 2026 17:09:05 +0000

My Intel email is going to bounce soon.  Map it to my personal Gmail
address.

Link: https://lkml.kernel.org/r/20260223170905.278956-1-daniele.alessandrelli@intel.com
Signed-off-by: Daniele Alessandrelli <daniele.alessandrelli@intel.com>
Cc: Daniele Alessandrelli <daniele.alessandrelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-daniele-alessandrelli
+++ a/.mailmap
@@ -211,6 +211,7 @@ Daniel Borkmann <daniel@iogearbox.net> <
 Daniel Borkmann <daniel@iogearbox.net> <dborkman@redhat.com>
 Daniel Borkmann <daniel@iogearbox.net> <dxchgb@gmail.com>
 Daniel Thompson <danielt@kernel.org> <daniel.thompson@linaro.org>
+Daniele Alessandrelli <daniele.alessandrelli@gmail.com> <daniele.alessandrelli@intel.com>
 Danilo Krummrich <dakr@kernel.org> <dakr@redhat.com>
 David Brownell <david-b@pacbell.net>
 David Collins <quic_collinsd@quicinc.com> <collinsd@codeaurora.org>
_

Patches currently in -mm which might be from daniele.alessandrelli@intel.com are


