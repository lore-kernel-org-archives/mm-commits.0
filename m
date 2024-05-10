Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF794AEC8
	for <mm-commits@vger.kernel.org>; Fri, 10 May 2024 19:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715370971; cv=none; b=h0LsjNhJdUZGjno8elBIM8mDgUXzjmm5N6BNMhHcMOHMrVhH1Z1i8gOJ028aE+mq+v9r89MRVz/6ieeLPTYQV14l4KGGifiArfJiT7G9W+aox83nnOxbm7gaBudiq3EtOy87atb8H0o+hNMOOzMPQv2W1ixY61Rdgi7/rEpEwr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715370971; c=relaxed/simple;
	bh=8eUzVT3Vc9jU11YGoEoImxXKXlKm5awew2SEul7jZkA=;
	h=Date:To:From:Subject:Message-Id; b=jgH0cvIT5Y6tY6IMWi3I0Oz3DCHZuNhH2mDyiLsuJTup0fYXMp9RQvUkjhne/arcUylnS/D7G9QwLtflB+7OZXDnvHUTK/OJ1bVXloiMXO3YXcqfE+nzlZ9tXVesKXXMoUp8FaqWcLXhQF5qmlXJirUDXx/wLIZ9mOhPMlxw/OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ipgiwivo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ipgiwivo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88ACC113CC;
	Fri, 10 May 2024 19:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715370970;
	bh=8eUzVT3Vc9jU11YGoEoImxXKXlKm5awew2SEul7jZkA=;
	h=Date:To:From:Subject:From;
	b=IpgiwivoCFnT8lOg7c8wdiRSICNHr0+Ikaug28yBjECc064egJq5wAast2jyz6rnT
	 NOw1+4eHUhu7WRs6oArKtY5AskyvAD1E6Jt5jL1vQTQonFEw6OmyLeZgZDyLqNXkGb
	 eJdQGBN3daLmjLQABLqSJmo2pFA2VKecdD+Vv2Rg=
Date: Fri, 10 May 2024 12:56:10 -0700
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entry-for-barry-song.patch removed from -mm tree
Message-Id: <20240510195610.C88ACC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entry for Barry Song
has been removed from the -mm tree.  Its filename was
     mailmap-add-entry-for-barry-song.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mailmap: add entry for Barry Song
Date: Mon, 6 May 2024 16:20:09 +1200

Include a .mailmap entry to synchronize with both my past and current
emails.  Among them, three business mailboxes are dead.

Link: https://lkml.kernel.org/r/20240506042009.10854-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    5 +++++
 1 file changed, 5 insertions(+)

--- a/.mailmap~mailmap-add-entry-for-barry-song
+++ a/.mailmap
@@ -87,6 +87,11 @@ Baolin Wang <baolin.wang@linux.alibaba.c
 Baolin Wang <baolin.wang@linux.alibaba.com> <baolin.wang@spreadtrum.com>
 Baolin Wang <baolin.wang@linux.alibaba.com> <baolin.wang@unisoc.com>
 Baolin Wang <baolin.wang@linux.alibaba.com> <baolin.wang7@gmail.com>
+Barry Song <baohua@kernel.org> <21cnbao@gmail.com>
+Barry Song <baohua@kernel.org> <v-songbaohua@oppo.com>
+Barry Song <baohua@kernel.org> <song.bao.hua@hisilicon.com>
+Barry Song <baohua@kernel.org> <Baohua.Song@csr.com>
+Barry Song <baohua@kernel.org> <barry.song@analog.com>
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@sandisk.com>
 Bart Van Assche <bvanassche@acm.org> <bart.vanassche@wdc.com>
 Bartosz Golaszewski <brgl@bgdev.pl> <bgolaszewski@baylibre.com>
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

documentation-coding-style-ask-function-like-macros-to-evaluate-parameters.patch

