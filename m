Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B8221832A
	for <mm-commits@vger.kernel.org>; Thu,  7 Nov 2024 22:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731017737; cv=none; b=HJ1SA2gt8knjw+ijIGeSNnX6YOnKk9+1hY6RY0NyQsr8kKRkvmoryTaxvT2Zwh8xQ5F7SpSC4pRsW/FBARnM/ghobj4vvVz/RtHg5cvLOdKCQsRMUU/kTHcSWNhoS7OAXkrDj0afq9clfPQ+YS4vtmYD4ZE1j/P5asCpIXgSOJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731017737; c=relaxed/simple;
	bh=/yvwQ50OCdecTGijgyrx0NHlKw+O0o1vwL/d4Ln/7V0=;
	h=Date:To:From:Subject:Message-Id; b=ZjTpKHL8ehX9mIyure/N4XQfQw4n2kSlW61sGXFML+sT7ms/02KEtn0Iuc8+j214a5mq6KWokf5FP6G5XQCdnYCW2DLSbrYCdM9nVXJtvVvmOIAWtFQCgGUl1Yd6pu22Ruur5Nr6hFlklCJNZi2UrAaWc3yJ4pfJpcGkQGgOap4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HunxW5z2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HunxW5z2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3D7C4AF0B;
	Thu,  7 Nov 2024 22:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731017736;
	bh=/yvwQ50OCdecTGijgyrx0NHlKw+O0o1vwL/d4Ln/7V0=;
	h=Date:To:From:Subject:From;
	b=HunxW5z2S73e05bVdyW+wVBYsXRa3ljQ4qBqy0apb0QLQGeSZuTdyWoyRKfqLHRJL
	 rZyBRDLKugSqlcM0FCuYKL9nKr8odrDd+Mc+pKe0m07R35oaN7ErA9b8PDOk3knPbH
	 8QAailDtYO3pauUOfLWov/5NfW6LQ4L36mbi6qsI=
Date: Thu, 07 Nov 2024 14:15:36 -0800
To: mm-commits@vger.kernel.org,qmo@kernel.org,neeraj.upadhyay@kernel.org,nao.horiguchi@gmail.com,m.othacehe@gmail.com,matttbe@kernel.org,matt@ranostay.sg,kees@kernel.org,geliang@kernel.org,elder@kernel.org,davem@davemloft.net,thorsten.blum@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-thorsten-blum.patch removed from -mm tree
Message-Id: <20241107221536.BE3D7C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entry for Thorsten Blum
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-thorsten-blum.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Blum <thorsten.blum@linux.dev>
Subject: mailmap: add entry for Thorsten Blum
Date: Mon, 4 Nov 2024 00:44:09 +0100

Map my previously used email address to my @linux.dev address.

Link: https://lkml.kernel.org/r/20241103234411.2522-2-thorsten.blum@linux.dev
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Alex Elder <elder@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geliang Tang <geliang@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Mathieu Othacehe <m.othacehe@gmail.com>
Cc: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Cc: Matt Ranostay <matt@ranostay.sg>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Cc: Quentin Monnet <qmo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-entry-for-thorsten-blum
+++ a/.mailmap
@@ -665,6 +665,7 @@ Tomeu Vizoso <tomeu@tomeuvizoso.net> <to
 Thomas Graf <tgraf@suug.ch>
 Thomas Körper <socketcan@esd.eu> <thomas.koerper@esd.eu>
 Thomas Pedersen <twp@codeaurora.org>
+Thorsten Blum <thorsten.blum@linux.dev> <thorsten.blum@toblux.com>
 Tiezhu Yang <yangtiezhu@loongson.cn> <kernelpatch@126.com>
 Tingwei Zhang <quic_tingwei@quicinc.com> <tingwei@codeaurora.org>
 Tirupathi Reddy <quic_tirupath@quicinc.com> <tirupath@codeaurora.org>
_

Patches currently in -mm which might be from thorsten.blum@linux.dev are

mm-show_mem-use-str_yes_no-helper-in-show_free_areas.patch

