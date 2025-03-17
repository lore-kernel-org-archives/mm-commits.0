Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674AD140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189533; cv=none; b=C/3CoSrulslvj4TBYnyEiQtuNI9WCQ/xBe+03tdaCOlm9U9ZG8aC3UzXQH/KFr7HceUxcaGCoZZAMZxLwgz2p5YtGWCc6h9n8/g2C10bVfJEwy1JJccwFWtP2/XY1IjcSRvmz0x7cQ/YbETU5+Uc9XNh8a/TRd9YSNNnhVzMI1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189533; c=relaxed/simple;
	bh=86Grh1WdD3IP74uih9kUVYNIr83UmdPYP+/rwA1nBso=;
	h=Date:To:From:Subject:Message-Id; b=SubLQzYVr41aI4vT7QUkQozZMEdtDiTqZqbGKRXwj1AYQl61KORZulSYgKNuZZeYaA8KVO8xKlEfkpJY9ZjOD9adhCtywr+AMA4h6isMtOoY+wcGViCg7JK11gF158qusElkLAIq7+AXvbVqbAuq6MM30x2IYuJaNhFtbCNwHIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qh8H73+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qh8H73+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EA1C4CEEC;
	Mon, 17 Mar 2025 05:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189533;
	bh=86Grh1WdD3IP74uih9kUVYNIr83UmdPYP+/rwA1nBso=;
	h=Date:To:From:Subject:From;
	b=qh8H73+wNUqLi2qamZkZeDv9pP+ykF2+P+5CM32Ktp1ZzpwVfx/JU3XEvAArG+1yi
	 f3dcpKKyZAV/1DQrXGaHfhizf49Q6lVNflpky5BnfHB8cYCmQ6SpDJeXAIqatOekcK
	 zfzmx1HF47ucn5h1SYWw3iNGwjw4FCjF01d6xpCk=
Date: Sun, 16 Mar 2025 22:32:12 -0700
To: mm-commits@vger.kernel.org,sw@simonwunderlich.de,quic_skakitap@quicinc.com,qmo@kernel.org,othacehe@gnu.org,nao.horiguchi@gmail.com,kees@kernel.org,gregkh@linuxfoundation.org,eugen.hristev@linaro.org,elder@kernel.org,antonio@mandelbit.com,jarkko@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mailmap-remove-never-used-parityio-email.patch removed from -mm tree
Message-Id: <20250317053213.38EA1C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: remove never used @parity.io email
has been removed from the -mm tree.  Its filename was
     mailmap-remove-never-used-parityio-email.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jarkko Sakkinen <jarkko@kernel.org>
Subject: mailmap: remove never used @parity.io email
Date: Tue, 18 Feb 2025 19:05:55 +0200

As this employment lasted only four months and was never used over here,
let's just rip it off for good.

Link: https://lkml.kernel.org/r/20250218170557.68371-1-jarkko@kernel.org
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Alex Elder <elder@kernel.org>
Cc: Antonio Quartulli <antonio@mandelbit.com>
Cc: Eugen Hristev <eugen.hristev@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Mathieu Othacehe <othacehe@gnu.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Quentin Monnet <qmo@kernel.org>
Cc: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 -
 1 file changed, 1 deletion(-)

--- a/.mailmap~mailmap-remove-never-used-parityio-email
+++ a/.mailmap
@@ -302,7 +302,6 @@ Jan Glauber <jan.glauber@gmail.com> <jgl
 Jan Kuliga <jtkuliga.kdev@gmail.com> <jankul@alatek.krakow.pl>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@linux.intel.com>
 Jarkko Sakkinen <jarkko@kernel.org> <jarkko@profian.com>
-Jarkko Sakkinen <jarkko@kernel.org> <jarkko.sakkinen@parity.io>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@mellanox.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgg@nvidia.com>
 Jason Gunthorpe <jgg@ziepe.ca> <jgunthorpe@obsidianresearch.com>
_

Patches currently in -mm which might be from jarkko@kernel.org are


