/// 敌人状态
enum EnemyState {
  /// 巡逻
  patrol,

  /// 追击
  chase,

  /// 攻击
  attack;

  @override
  String toString() => super.toString().replaceFirst("(E|e)nemy[S|s]tate.", "");
}
