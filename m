Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78055C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 06:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51CCF61037
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 06:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhJVG5T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 22 Oct 2021 02:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbhJVG5T (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 22 Oct 2021 02:57:19 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192A3C061764
        for <mm-commits@vger.kernel.org>; Thu, 21 Oct 2021 23:55:02 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HbFTV5jkfz4xbP;
        Fri, 22 Oct 2021 17:54:54 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1634885699;
        bh=LNKVs7AFifokPyFWFa8TKJjA78tjmPUhrm55qZBu/dE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TSKt0uNWY0gtZQw+Yq6jsjw0S93TqEZoAVUqPHJ5OxO6yQwtsmKatkr7iRId74Xl5
         2jFyMpL9Ugo+xyvrjIIVVLVEHNrFkdqh1CyT2h56uXdKhAZyPlTNhTXyMZkLDBPd8L
         zk2XrxHZyWQza1xN6Zxl+9IwiXXpCyX0RuV6g5NjQ6B/H9wQzxCQm638INFm+OQ7i7
         sSHzy/9KuEMKWC77vkLa4LSoc1LdTXePMLSJ8fBPviR48STXnYSBTMneJmlZTFr0AZ
         N5HuXx33mMJXVSdnlMumsze1S4BjXfxeQ0IIrR07BXtfb9yWoKgX//caDFT1t+rRTY
         RpCybDvfd3KHQ==
Date:   Fri, 22 Oct 2021 17:54:53 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     airlied@linux.ie, andreyknvl@gmail.com, daniel@ffwll.ch,
        dvyukov@google.com, elver@google.com, geert@linux-m68k.org,
        glider@google.com, glittao@gmail.com, imran.f.khan@oracle.com,
        jani.nikula@intel.com, maarten.lankhorst@linux.intel.com,
        mm-commits@vger.kernel.org, mripard@kernel.org,
        naresh.kamboju@linaro.org, ryabinin.a.a@gmail.com,
        tzimmermann@suse.de, vbabka@suse.cz, vjitta@codeaurora.org
Subject: Re: +
 lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvmalloc-fixup3.patch
 added to -mm tree
Message-ID: <20211022175453.078cfa07@canb.auug.org.au>
In-Reply-To: <20211022033904.5G4B3GgXM%akpm@linux-foundation.org>
References: <20211022033904.5G4B3GgXM%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+zyQUz=nA4nAq0KkJnTcmO9";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/+zyQUz=nA4nAq0KkJnTcmO9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 21 Oct 2021 20:39:04 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: lib/stackdepot: allow optional init and stack_table allocat=
ion by kvmalloc() - fixup3
> has been added to the -mm tree.  Its filename is
>      lib-stackdepot-allow-optional-init-and-stack_table-allocation-by-kvm=
alloc-fixup3.patch

Added to linux-next today (in the post linux-next part of the akpm
tree).
--=20
Cheers,
Stephen Rothwell

--Sig_/+zyQUz=nA4nAq0KkJnTcmO9
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFyYD4ACgkQAVBC80lX
0Gzn+QgAgz3R8xulmdFpGunPNdJ7RM+8d8X9G3j3HbvkW+usJxwVAKc8KEBMNCKU
qNELIDH6WV6tPhq41KLZd1qGbp2Dtg65cCctHwrFdUGt13eEm1EOyptbyHqsfFB/
CTlK1Tkus4OrbyJa6gIswYfWrsmaAxQ/ibrrBvRKmV+CtzXhxvaIWzswKz46yG1b
UTx12TRz82UjPAnJUUex805uleYLyZ2MP3bTLe4EB1n23YmMuyjFu09YITQNXMLe
NQJL8GagyfQPy6yD7y11ox6HQiDlCv35VNNMgzpQhk89/NCk2eGVbQfVEBPIk/K+
7WTR1cQiuDQafNGAOBfEbDGXLle/wg==
=Q0ae
-----END PGP SIGNATURE-----

--Sig_/+zyQUz=nA4nAq0KkJnTcmO9--
