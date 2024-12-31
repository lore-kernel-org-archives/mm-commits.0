Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DF2FC0B
	for <mm-commits@vger.kernel.org>; Tue, 31 Dec 2024 02:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735610400; cv=none; b=ajKnOYi/lrE7ggS4nhpIufCfIltD+oVMJmNZQd/dY6AxGhNq53HS+TKSTY6IV6Qv8j/9dtI8cn+2CDJtm5+6JwFyZBg9oBlxs1OjHn6WqVG6vZwHCGGjZlF/PRdvMhol7kAAiFiQdqNIdvoFn1ijUanQiTg0oVARLi7UpJj54vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735610400; c=relaxed/simple;
	bh=yVf1vFPVQPjrEQYgaOU7trpsT8JvEgutvlnwWawK7I8=;
	h=Date:To:From:Subject:Message-Id; b=E2GHAhJ8LZoJCZIqx+rJVMGLKgCdCuwYr5yUxGBwQyKa67xeWmzswcQKwRr4GP5hhQyPB5ZRSNjcGyhXHqn5PNcH0VJLEfzOiqMRCJI5ZtmBbZDDvrhSWlZ//aVg3SJzG2h++v699DCi9YvyTwZ2g/p1nUFwj8KhmZi9st0P994=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mxz/j6Tp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mxz/j6Tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7ADC4CED0;
	Tue, 31 Dec 2024 02:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735610400;
	bh=yVf1vFPVQPjrEQYgaOU7trpsT8JvEgutvlnwWawK7I8=;
	h=Date:To:From:Subject:From;
	b=mxz/j6TpGkv1sHEvv1qsmvUaEOg/opEhg9nRHHre6OhTxqloZLLurfncRDLpvyJ/g
	 U/ayS/bsUTbfH/yCd3MQMgRZOoDVFFKMV7sX4G5pMKWZIkVBsV/C2mZi6ogz5TSLTy
	 ufM4z02Q37NrY03K09J73O7iMgFgAZ1Kx1ZiSmCE=
Date: Mon, 30 Dec 2024 17:59:59 -0800
To: mm-commits@vger.kernel.org,qmo@kernel.org,neeraj.upadhyay@kernel.org,matttbe@kernel.org,kees@kernel.org,geliang@kernel.org,elder@kernel.org,davem@davemloft.net,othacehe@gnu.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-modify-the-entry-for-mathieu-othacehe.patch removed from -mm tree
Message-Id: <20241231020000.6C7ADC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: modify the entry for Mathieu Othacehe
has been removed from the -mm tree.  Its filename was
     mailmap-modify-the-entry-for-mathieu-othacehe.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mathieu Othacehe <othacehe@gnu.org>
Subject: mailmap: modify the entry for Mathieu Othacehe
Date: Tue, 17 Dec 2024 11:09:21 +0100

Set my gnu address as the main one.

Link: https://lkml.kernel.org/r/20241217100924.7821-1-othacehe@gnu.org
Signed-off-by: Mathieu Othacehe <othacehe@gnu.org>
Cc: Alex Elder <elder@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geliang Tang <geliang@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Cc: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Cc: Quentin Monnet <qmo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/.mailmap~mailmap-modify-the-entry-for-mathieu-othacehe
+++ a/.mailmap
@@ -435,7 +435,7 @@ Martin Kepplinger <martink@posteo.de> <m
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@puri.sm>
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@theobroma-systems.com>
 Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com> <martyna.szapar-mudlaw@intel.com>
-Mathieu Othacehe <m.othacehe@gmail.com> <othacehe@gnu.org>
+Mathieu Othacehe <othacehe@gnu.org> <m.othacehe@gmail.com>
 Mat Martineau <martineau@kernel.org> <mathew.j.martineau@linux.intel.com>
 Mat Martineau <martineau@kernel.org> <mathewm@codeaurora.org>
 Matthew Wilcox <willy@infradead.org> <matthew.r.wilcox@intel.com>
_

Patches currently in -mm which might be from othacehe@gnu.org are


