Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD401552FD
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 02:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782957825; cv=none; b=chhZrBdjszhM2vkr/rRSXgYkOyKCzjcJNNSXUjRgIOk0m6gGMWOlfkitBQM44nWkuisbchRwiqmw7JjRF3653DZMSt3RVmljJhkYTXTsTff1f7n2zNeqlEy2xDsKeJYzhGurvKAXWgChjYMU22fVgXMNRCNZw6CEI1oMYBPvaoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782957825; c=relaxed/simple;
	bh=Vp9YzDyu+Ts1jxSVUGzhAfPFwSs1uysd7mZ0gm8KbRI=;
	h=Date:To:From:Subject:Message-Id; b=gfWOrcVneA5WhlUJp3TLeuQiSWPEjG7XfOrBzdav1hDMtJVhr6Qx4LJYNJVBaIKa7R2+6XaokVh9crKoJLy9nAhbKDBgRG8tyx8MwvobSza84Qhl/9yOVlDStsGSq1ixffKm2M/kNI0TdiC18Z5ZdVpczwdE52d2UTETrKIdh28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SsMKtnkk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SsMKtnkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED471F00A3A;
	Thu,  2 Jul 2026 02:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782957823;
	bh=ofNTo+vjCWakjAZXYDEA4ZCqGSLhuBtz7nj109tTCzI=;
	h=Date:To:From:Subject;
	b=SsMKtnkkswENQkj/IWUajwOClKQN7yPiYQbZDSHWD/sbidyrQeKSpS8qSn0DdlqEz
	 G8GyrB9BUvjxOMeOIhIzSpmzIQe+3uArReYGlOlBYku63YXLhtpZnzTNg+G6cJu7o9
	 m6dPQ4TSnXrjGhsXqlRmMeMw10NpVQzmr+JLpD0A=
Date: Wed, 01 Jul 2026 19:03:42 -0700
To: mm-commits@vger.kernel.org,kuba@kernel.org,radu@rendec.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entries-for-radu-rendec.patch removed from -mm tree
Message-Id: <20260702020342.DED471F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entries for Radu Rendec
has been removed from the -mm tree.  Its filename was
     mailmap-add-entries-for-radu-rendec.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Radu Rendec <radu@rendec.net>
Subject: mailmap: add entries for Radu Rendec
Date: Sun, 28 Jun 2026 11:02:03 -0400

I have used multiple email addresses for my kernel contributions, and some
of them are no longer active.  Add all to .mailmap for clarity.

Link: https://lore.kernel.org/20260628150203.4105796-1-radu@rendec.net
Signed-off-by: Radu Rendec <radu@rendec.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    4 ++++
 1 file changed, 4 insertions(+)

--- a/.mailmap~mailmap-add-entries-for-radu-rendec
+++ a/.mailmap
@@ -708,6 +708,10 @@ Qi Zheng <qi.zheng@linux.dev> <zhengqi.a
 Quentin Monnet <qmo@kernel.org> <quentin.monnet@netronome.com>
 Quentin Monnet <qmo@kernel.org> <quentin@isovalent.com>
 Quentin Perret <qperret@qperret.net> <quentin.perret@arm.com>
+Radu Rendec <radu@rendec.net> <radu.rendec@ines.ro>
+Radu Rendec <radu@rendec.net> <rrendec@arista.com>
+Radu Rendec <radu@rendec.net> <radu.rendec@gmail.com>
+Radu Rendec <radu@rendec.net> <rrendec@redhat.com>
 Rae Moar <raemoar63@gmail.com> <rmoar@google.com>
 Rafael J. Wysocki <rjw@rjwysocki.net> <rjw@sisk.pl>
 Rajeev Nandan <quic_rajeevny@quicinc.com> <rajeevny@codeaurora.org>
_

Patches currently in -mm which might be from radu@rendec.net are


