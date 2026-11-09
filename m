Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794202153;
	b=JIRc4fiiMCaSVYch3MQdUfV7Y3od6e+kfp/EVFtVC8dJ5D1FJGnQ0wgOk9Cojaf7yeP/
	 HFcA4IccQfHc1l9OPc2arLDCl4Ru9i0EEuB7nEPQrcv884HFFSH6hGXt+TCdfqf95ypM8
	 rHttbqoQo9hiSQvQkNdEwYYtoZv186A3xng5nReoZXQtkBqnDV1tKsOkEqFxnxSzVwIIk
	 1ZYQ9PAzfpU4faXM5ioqCN2KjIcSNoCLRJnIB+PhpTQVYzAOgIKoEuf5IWxueh1mBbBtR
	 +ykCB7/TqtuTaEGNqOwmvAYWBYKW76UTRuZUOj1wr6tEgI8u6gc+gzrbA1GqiRiIEaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794202153;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=zqzhNh28hKgArtz7i37m9IzvG0SNhkOY9blsKLIqszI=;
	b=cqlo0GEj6ggbkAM6mhjQRxx/LdOeO5xzFdK74UsCROPq7bVNOrair2KPEJ6AVtUZTFR0
	 eFlACG4wNvP3cI0IFi7xB+4nOk2Y4RHtrhAahqggftBQeXhPZKv1fEhiH64dPssyC3/0c
	 khAeHJAz4oOQwAWmyNOCE/pKH9fzw4NTcDrxSp5vXnrxIZv9luje267C9lzWDAi0T1YpU
	 P7g8B543NmZzQtuou+xlCQxDtbx+SW3GhTJNuRhJ9cdVbdwH1yu16AFxmlQVoPIzuuZs7
	 AUQgRECnbAVWDhUmDhFcPbY5mLmP9UKwvq+M+fBYPQvDTMzCH59PCnAfSMnHTeCQjwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=q9D5ZeWN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B19606D838
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 05:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=q9D5ZeWN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE361F00903;
	Mon,  9 Nov 2026 05:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794202153;
	bh=zqzhNh28hKgArtz7i37m9IzvG0SNhkOY9blsKLIqszI=;
	h=Date:To:From:Subject;
	b=q9D5ZeWN5/h5ymOvbVQsN/JA8473KDqbTNaxPNWIXJ5j/xVvBJohYH64bz0qxGTvA
	 ihIwUWe+AIcpTpFwgNvbYMYGAGoocY30CoQ43ajFxSnqYUQOfm8xXlhdaWlEjup/8a
	 c/q5K4ZV+EietZRKo6yu57Bz4Fbrdq7sOq+N5zCI=
Date: Sun, 08 Nov 2026 21:29:12 -0800
To: mm-commits@vger.kernel.org,wangyibo@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-wang-yibos-work-email-address.patch added to mm-nonmm-unstable branch
Message-Id: <20261109052912.DDE361F00903@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mailmap: add Wang Yibo's work email address
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mailmap-add-wang-yibos-work-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-wang-yibos-work-email-address.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Wang Yibo <wangyibo@kylinos.cn>
Subject: mailmap: add Wang Yibo's work email address
Date: Mon,  9 Nov 2026 11:06:51 +0800

My kernel work will be signed off with my company address from now on.
Add it to .mailmap and map the personal address I used before to it, so
that both resolve to the same author in git log and git shortlog.

Link: https://lore.kernel.org/20261109030651.2289573-1-wangyibo@kylinos.cn
Signed-off-by: Wang Yibo <wangyibo@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-wang-yibos-work-email-address
+++ a/.mailmap
@@ -1006,6 +1006,7 @@ Vlad Dogaru <ddvlad@gmail.com> <vlad.dog
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@parallels.com>
 Vladimir Davydov <vdavydov.dev@gmail.com> <vdavydov@virtuozzo.com>
 Vlastimil Babka <vbabka@kernel.org> <vbabka@suse.cz>
+Wang Yibo <wangyibo@kylinos.cn> <szwyb123@gmail.com>
 WangYuli <wangyuli@aosc.io> <wangyl5933@chinaunicom.cn>
 WangYuli <wangyuli@aosc.io> <wangyuli@deepin.org>
 Wei Wang <weiwan@google.com> <weibunny@fb.com>
_

Patches currently in -mm which might be from wangyibo@kylinos.cn are

mailmap-add-wang-yibos-work-email-address.patch

