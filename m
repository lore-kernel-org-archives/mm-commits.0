Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93949C63777
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 08:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DCB520719
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 08:38:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="Z1Cbonz4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgK3Ih7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Nov 2020 03:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbgK3Ih7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2020 03:37:59 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE34C0613D2
        for <mm-commits@vger.kernel.org>; Mon, 30 Nov 2020 00:37:19 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CkzB01l9fz9sTv;
        Mon, 30 Nov 2020 19:37:12 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1606725434;
        bh=6nlHwAkJXoFjHChYimXP6RycyHhCFbkkKTx6E71JuAI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z1Cbonz4QJD+9AFD6CRgMYMJiA+UZIxVf5lnFlr6cVA8qC15kA47B5zRqi0hjiiov
         boDYLs4SsKVCTSBcQ4IZ8TmBe2YqRA4fpmYAP5n2yyUR0ZSw3nTBkM5zn1vXQ9JL03
         O4CMahgo3vGsZyS4dz/l4Pn/XPeODl5dBXB27nhyIRqSApCK4j/kR5jMgCZFotubj/
         LDBgZojqnUN/lPAtwDc9jUp7Le+BPNMx7qdXM5yzreDRaqCCWCy/Y+K4PR4njmjnyB
         eTMEC9L2uxIOK2F5Mz4zdWWJ+/2gNmyBcnZRIDh9gNaHzufg9FSkmMdu1qy5h8vVWT
         ZD3FexzL2p62w==
Date:   Mon, 30 Nov 2020 19:37:11 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     alex.shi@linux.alibaba.com, alexander.h.duyck@linux.intel.com,
        guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com,
        lstoakes@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, shakeelb@google.com
Subject: Re: + mm-memcg-bail-out-early-when-memcg-in-mem_cgroup_lruvec.patch
 added to -mm tree
Message-ID: <20201130193711.6b0fc022@canb.auug.org.au>
In-Reply-To: <20201129235806.-epVwaSUd%akpm@linux-foundation.org>
References: <20201129235806.-epVwaSUd%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/o5pSAFYRBh.rFJZWEm0TrR0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/o5pSAFYRBh.rFJZWEm0TrR0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Sun, 29 Nov 2020 15:58:06 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm/memcg: bail out early when !memcg in mem_cgroup_lruvec
> has been added to the -mm tree.  Its filename is
>      mm-memcg-bail-out-early-when-memcg-in-mem_cgroup_lruvec.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/o5pSAFYRBh.rFJZWEm0TrR0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/ErzcACgkQAVBC80lX
0GzwXwf+LgeZqYEspr1OA5Nnm8nw4JLxhee3Jy3j2p+QoxJKqqHzqVfIHgKnxcVJ
6vgGbB5J+9mEkavSNvABGVGOsLZv3Ph+qw8/DSiFN2xfaJd1S+FpkXlVvqvUk+O6
IyVy2gT8RiSYqo9nBOR3deWK2HgU8YR3uebxiM7XTp/rRmyYmrZTtGEHlIIEN+M0
C07RXb04G81EWQTHzc9t0Sf+5N9aWXdj227vuU/1gPsM5HH1xZBwq+GnZkfUOwhJ
My1fgo0BZerbyVDhZ/8uFYM8753UBgyljjw7lQ1IX7qssgS8M+eRww6mA/wqI2AO
PdTtQtTELYwSm9FT3YIFYZAxBpe2tw==
=6x60
-----END PGP SIGNATURE-----

--Sig_/o5pSAFYRBh.rFJZWEm0TrR0--
